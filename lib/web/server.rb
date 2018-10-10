# frozen_string_literal: true

require 'oj'
require 'rack/cors'
require 'redcarpet'
require 'sass/plugin/rack'
require 'sinatra'

require 'currency_names'
require 'query'
require 'quote'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :get
  end
end

css_location = File.join(Sinatra::Application.public_folder, 'stylesheets')
Sass::Plugin.options.update css_location: css_location,
                            style: :compressed
use Sass::Plugin::Rack

configure :development do
  set :show_exceptions, :after_handler
end

configure :production do
  disable :dump_errors
end

configure :test do
  set :raise_errors, false
end

set :static_cache_control, [:public, max_age: 300]

helpers do
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

get '/' do
  # FIXME: We should cache this in production.
  parser = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
                                   disable_indented_code_blocks: true,
                                   fenced_code_blocks: true)
  content = parser.render(File.read('README.md'))

  erb :index, locals: { content: content }
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

get '/(?<start_date>\d{4}-\d{2}-\d{2})\.\.(?<end_date>\d{4}-\d{2}-\d{2})?',
    mustermann_opts: { type: :regexp } do
  @params[:end_date] ||= Date.today.to_s
  etag interval_quote.cache_key
  json interval_quote.formatted
end

get '/currencies' do
  currency_names = CurrencyNames.new
  etag currency_names.cache_key
  json currency_names.formatted
end

not_found do
  halt 404
end

error do
  halt 422
end
