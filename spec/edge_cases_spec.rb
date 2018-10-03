# frozen_string_literal: true

require_relative 'helper'
require 'rack/test'
require 'web/server'

describe 'the server' do
  include Rack::Test::Methods

  let(:app) { Sinatra::Application }

  def json
    Oj.load(last_response.body)
  end

  it 'handles unfound pages' do
    get '/foo'
    last_response.status.must_equal 404
  end

  it 'will not process an invalid date' do
    get '/2010-31-01'
    last_response.must_be :unprocessable?
  end

  it 'will not process a date before 2000' do
    get '/1999-01-01'
    last_response.must_be :not_found?
  end

  it 'will not process an invalid base' do
    get '/latest?base=UAH'
    last_response.must_be :unprocessable?
  end

  it 'handles malformed queries' do
    get '/latest?base=USD?callback=?'
    last_response.must_be :unprocessable?
  end

  it 'does not return stale dates' do
    Day.db.transaction do
      get '/latest'
      date = json['date']
      Day.latest.delete
      get '/latest'
      json['date'].wont_equal date
      raise Sequel::Rollback
    end
  end
end
