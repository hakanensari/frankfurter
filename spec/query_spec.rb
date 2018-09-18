# frozen_string_literal: true

require_relative 'helper'
require 'query'

describe Query do
  it 'returns given amount' do
    query = Query.new(amount: '100')
    query.amount.must_equal 100.0
  end

  it 'defaults amount to nothing' do
    query = Query.new
    query.amount.must_be_nil
  end

  it 'returns given base' do
    query = Query.new(base: 'USD')
    query.base.must_equal 'USD'
  end

  it 'upcases given base' do
    query = Query.new(base: 'usd')
    query.base.must_equal 'USD'
  end

  it 'defaults base to nothing' do
    query = Query.new
    query.base.must_be_nil
  end

  it 'aliases base with from' do
    query = Query.new(from: 'USD')
    query.base.must_equal 'USD'
  end

  it 'returns given symbols' do
    query = Query.new(symbols: 'USD,GBP')
    query.symbols.must_equal %w[USD GBP]
  end

  it 'upcases given symbols' do
    query = Query.new(symbols: 'usd,gbp')
    query.symbols.must_equal %w[USD GBP]
  end

  it 'aliases symbols with to' do
    query = Query.new(to: 'USD')
    query.symbols.must_equal ['USD']
  end

  it 'defaults symbols to nothing' do
    query = Query.new
    query.symbols.must_be_nil
  end

  it 'returns given date' do
    date = '2014-01-01'
    query = Query.new(date: date)
    query.date.must_equal Date.parse(date)
  end

  it 'returns given date interval' do
    start_date = '2014-01-01'
    end_date = '2014-12-31'
    query = Query.new(start_date: start_date, end_date: end_date)
    query.date.must_equal((Date.parse(start_date)..Date.parse(end_date)))
  end
end
