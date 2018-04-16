# frozen_string_literal: true

require_relative 'helper'
require 'quote'

describe Quote do
  describe 'by default' do
    it 'quotes against the Euro' do
      quote = Quote.new
      rates = quote.to_h[:rates]
      rates.keys.wont_include 'EUR'
    end
  end

  describe 'when given a base' do
    it 'quotes against that base' do
      quote = Quote.new(base: 'USD')
      rates = quote.to_h[:rates]
      rates.keys.wont_include 'USD'
    end

    it 'sorts rates' do
      quote = Quote.new(base: 'USD')
      rates = quote.to_h[:rates]
      rates.keys.must_equal rates.keys.sort
    end
  end

  describe 'when given symbols' do
    it 'quotes rates only for given symbols' do
      quote = Quote.new(symbols: ['USD'])
      rates = quote.to_h[:rates]
      rates.keys.must_include 'USD'
      rates.keys.wont_include 'GBP'
    end
  end

  describe 'when given an amount' do
    it 'quotes for that amount' do
      quote = Quote.new(amount: 100)
      rates = quote.to_h[:rates]
      rates['USD'].must_be :>, 10
    end
  end

  describe 'when given an amount and symbols' do
    it 'quotes for that amount' do
      quote = Quote.new(amount: 100, symbols: ['USD'])
      rates = quote.to_h[:rates]
      rates['USD'].must_be :>, 10
    end
  end
end
