# frozen_string_literal: true

require 'oj'
require 'rack/cors'
require 'sinatra'

require 'query'
require 'quote'

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: :get
  end
end

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
  def quote
    @quote ||= begin
      query = Query.new(params)
      Quote.new(query.to_h)
    end
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

get '*' do
  cache_control :public
  pass
end

get '/' do
  erb :index
end

get '/(?:latest|current)', mustermann_opts: { type: :regexp } do
  last_modified quote.date
  json quote.to_h
end

get '/(?<date>\d{4}-\d{2}-\d{2})', mustermann_opts: { type: :regexp } do
  last_modified quote.date
  json quote.to_h
end

get '/(?<start_date>\d{4}-\d{2}-\d{2})\.\.(?<end_date>\d{4}-\d{2}-\d{2})', mustermann_opts: { type: :regexp } do
  last_modified quote.end_date
  json quote.to_h
end

not_found do
  halt 404
end

error do
  halt 422
end
