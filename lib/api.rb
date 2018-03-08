# frozen_string_literal: true

require 'oj'
require 'sinatra'
require 'rack/cors'

require 'query'
require 'quotation'

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
  def quotation
    @quotation ||= begin
      query = Query.new(params)
      Quotation.new(query.to_h)
    end
  end

  def jsonp(data)
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
  cache_control :public, :must_revalidate, max_age: 900
  pass
end

get '/' do
  jsonp source: 'https://github.com/hakanensari/fixer'
end

get '/latest' do
  last_modified quotation.date
  jsonp quotation.quote
end

get '/(?<date>\d{4}-\d{2}-\d{2})', mustermann_opts: { type: :regexp } do
  last_modified quotation.date
  jsonp quotation.quote
end

not_found do
  halt 404
end

error do
  halt 422
end
