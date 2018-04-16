# frozen_string_literal: true

require_relative '../helper'
require 'rack/test'
require 'web/server'

describe 'the server' do
  include Rack::Test::Methods

  let(:app)  { Sinatra::Application }
  let(:json) { Oj.load(last_response.body) }
  let(:headers) { last_response.headers }

  it 'has a homepage' do
    get '/'
    last_response.must_be :ok?
  end

  it 'returns current quotes' do
    get '/current'
    last_response.must_be :ok?
  end

  it 'sets base currency' do
    get '/current'
    res = Oj.load(last_response.body)
    get '/current?from=USD'
    json.wont_equal res
  end

  it 'sets base amount' do
    get '/current?amount=10'
    json['rates']['USD'].must_be :>, 10
  end

  it 'filters symbols' do
    get '/current?to=USD'
    json['rates'].keys.must_equal %w[USD]
  end

  it 'returns historical quotes' do
    get '/2012-11-20'
    json['rates'].wont_be :empty?
    json['date'].must_equal '2012-11-20'
  end

  it 'works around holidays' do
    get '/2010-01-01'
    json['rates'].wont_be :empty?
  end

  it 'returns a cache control header' do
    %w[/ /current /2012-11-20].each do |path|
      get path
      headers['Cache-Control'].wont_be_nil
    end
  end

  it 'returns a last modified header' do
    %w[/current /2012-11-20].each do |path|
      get path
      headers['Last-Modified'].wont_be_nil
    end
  end

  it 'allows cross-origin requests' do
    %w[/ /current /2012-11-20].each do |path|
      header 'Origin', '*'
      get path
      assert headers.key?('Access-Control-Allow-Methods')
    end
  end

  it 'responds to preflight requests' do
    %w[/ /current /2012-11-20].each do |path|
      header 'Origin', '*'
      header 'Access-Control-Request-Method', 'GET'
      header 'Access-Control-Request-Headers', 'Content-Type'
      options path
      assert headers.key?('Access-Control-Allow-Methods')
    end
  end

  it 'converts an amount' do
    get '/current?from=GBP&to=USD&amount=100'
    json['rates']['USD'].must_be :>, 100
  end

  it 'returns rates for a given period' do
    get '/2010-01-01..2010-12-31'
    json['start_date'].must_equal '2010-01-01'
    json['end_date'].must_equal '2010-12-31'
    json['rates'].wont_be empty
  end
end
