# frozen_string_literal: true

require 'oj'
require 'rack/cors'
require 'sass/plugin/rack'
require 'sinatra'

require 'query'
require 'quote'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :get
  end
end

Sass::Plugin.options[:style] = :compressed
use Sass::Plugin::Rack

set :static_cache_control, [:public, max_age: 60]

configure :development do
  set :show_exceptions, :after_handler
end

configure :production do
  disable :dump_errors
end

configure :test do
  set :raise_errors, false
end

helpers do
  def versioned_stylesheet(stylesheet)
    "/stylesheets/#{stylesheet}.css?" + File.mtime(File.join(Sinatra::Application.public_folder, 'stylesheets', 'sass', "#{stylesheet}.scss")).to_i.to_s
  end

  def versioned_javascript(javascript)
    "/javascripts/#{javascript}.js?" + File.mtime(File.join(Sinatra::Application.public_folder, 'javascripts', "#{javascript}.js")).to_i.to_s
  end

  def end_of_day_quote
    @end_of_day_quote ||= begin
      quote = Quote::EndOfDay.new(query)
      quote.perform
      halt 404 if quote.not_found?

      quote
    end
  end

  def interval_quote
    @interval_quote ||= begin
      quote = Quote::Interval.new(query)
      quote.perform
      halt 404 if quote.not_found?

      quote
    end
  end

  def query
    Query.new(params).to_h
  end

  def json(data)
    json = Oj.dump(data, mode: :compat)
    callback = params.delete('callback')

    if callback
      content_type :js
      "#{callback}(#{json})"
    else
      content_type :json
      json
    end
  end
end

options '*' do
  200
end

get '/' do
  erb :index
end

get '/(?:latest|current)', mustermann_opts: { type: :regexp } do
  params[:date] = Date.today.to_s
  etag end_of_day_quote.cache_key
  json end_of_day_quote.formatted
end

get '/(?<date>\d{4}-\d{2}-\d{2})', mustermann_opts: { type: :regexp } do
  etag end_of_day_quote.cache_key
  json end_of_day_quote.formatted
end

get '/(?<start_date>\d{4}-\d{2}-\d{2})\.\.(?<end_date>\d{4}-\d{2}-\d{2})',
    mustermann_opts: { type: :regexp } do
  etag interval_quote.cache_key
  json interval_quote.formatted
end

not_found do
  halt 404
end

error do
  halt 422
end
