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

  it 'returns latest quotes' do
    get '/latest'
    last_response.must_be :ok?
  end

  it 'sets base currency' do
    get '/latest'
    res = Oj.load(last_response.body)
    get '/latest?from=USD'
    json.wont_equal res
  end

  it 'sets base amount' do
    get '/latest?amount=10'
    json['rates']['USD'].must_be :>, 10
  end

  it 'filters symbols' do
    get '/latest?to=USD'
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

  it 'returns an ETag' do
    %w[/latest /2012-11-20].each do |path|
      get path
      headers['ETag'].wont_be_nil
    end
  end

  it 'allows cross-origin requests' do
    %w[/ /latest /2012-11-20].each do |path|
      header 'Origin', '*'
      get path
      assert headers.key?('Access-Control-Allow-Methods')
    end
  end

  it 'responds to preflight requests' do
    %w[/ /latest /2012-11-20].each do |path|
      header 'Origin', '*'
      header 'Access-Control-Request-Method', 'GET'
      header 'Access-Control-Request-Headers', 'Content-Type'
      options path
      assert headers.key?('Access-Control-Allow-Methods')
    end
  end

  it 'converts an amount' do
    get '/latest?from=GBP&to=USD&amount=100'
    json['rates']['USD'].must_be :>, 100
  end

  it 'returns rates for a given period' do
    get '/2010-01-01..2010-12-31'
    json['start_date'].wont_be :empty?
    json['end_date'].wont_be :empty?
    json['rates'].wont_be :empty?
  end

  it 'returns rates when given period does not include end date' do
    get '/2010-01-01..'
    json['start_date'].wont_be :empty?
    json['end_date'].wont_be :empty?
    json['rates'].wont_be :empty?
  end

  it 'returns currencies' do
    get '/currencies'
    json['USD'].must_equal 'United States Dollar'
  end
end
