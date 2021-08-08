# frozen_string_literal: true

require_relative '../helper'
require 'rack/test'
require 'web/server'

describe 'the server' do
  include Rack::Test::Methods

  let(:app) { Web::Server.freeze }
  let(:json) { Oj.load(last_response.body) }
  let(:headers) { last_response.headers }

  it 'returns link to docs' do
    get '/'
    _(json['docs']).wont_be_nil
  end

  it 'returns latest quotes' do
    get '/latest'
    _(last_response).must_be :ok?
  end

  it 'sets base currency' do
    get '/latest'
    res = Oj.load(last_response.body)
    get '/latest?from=USD'
    _(json).wont_equal res
  end

  it 'sets base amount' do
    get '/latest?amount=10'
    _(json['rates']['USD']).must_be :>, 10
  end

  it 'filters symbols' do
    get '/latest?to=USD'
    _(json['rates'].keys).must_equal %w[USD]
  end

  it 'returns historical quotes' do
    get '/2012-11-20'
    _(json['rates']).wont_be :empty?
    _(json['date']).must_equal '2012-11-20'
  end

  it 'works around holidays' do
    get '/2010-01-01'
    _(json['rates']).wont_be :empty?
    _(json['date']).must_equal '2009-12-31'
  end

  it 'returns an ETag' do
    %w[/latest /2012-11-20].each do |path|
      get path
      _(headers['ETag']).wont_be_nil
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
    _(json['rates']['USD']).must_be :>, 100
  end

  it 'returns rates for a given period' do
    get '/2010-01-01..2010-12-31'

    _(json['start_date']).wont_be :empty?
    _(json['start_date']).must_equal '2010-01-04' # ECB only has rates for working days
    _(json['end_date']).wont_be :empty?
    _(json['end_date']).must_equal '2010-12-31'
    _(json['rates']).wont_be :empty?
  end

  it 'returns rates when given period does not include end date' do
    get '/2010-01-01..'
    _(json['date']).wont_be :empty?
    _(json['rates']).wont_be :empty?
  end

  it 'returns currencies' do
    get '/currencies'
    _(json['USD']).must_equal 'United States Dollar'
  end

  it 'handles JSONP' do
    get '/latest?callback=foo'
    _(last_response.body).must_be :start_with?, '/**/foo'
  end

  it 'sets charset to utf-8' do
    get '/currencies'
    _(last_response.headers['content-type']).must_be :end_with?, 'charset=utf-8'
  end
end
