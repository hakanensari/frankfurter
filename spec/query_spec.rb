# frozen_string_literal: true

require_relative 'helper'
require 'query'

describe Query do
  it 'returns given amount' do
    query = Query.new(amount: '100')
    query.amount.must_equal 100.0
  end

  it 'defaults amount to nothin' do
    query = Query.new
    query.amount.must_be_nil
  end

  it 'returns given base' do
    query = Query.new(base: 'USD')
    query.base.must_equal 'USD'
  end

  it 'defaults base to nothing' do
    query = Query.new
    query.base.must_be_nil
  end

  it 'aliases base as from' do
    query = Query.new(from: 'USD')
    query.base.must_equal 'USD'
  end

  it 'returns given symbols' do
    query = Query.new(symbols: 'USD,GBP')
    query.symbols.must_equal %w[USD GBP]
  end

  it 'aliases symbols to to' do
    query = Query.new(to: 'USD')
    query.symbols.must_equal ['USD']
  end

  it 'defaults symbols to nothing' do
    query = Query.new
    query.symbols.must_be_nil
  end

  it 'returns given date' do
    query = Query.new(date: '2014-01-01')
    query.date.must_equal '2014-01-01'
  end

  it 'defaults date to nothing' do
    query = Query.new
    query.date.must_be_nil
  end
end
