# frozen_string_literal: true

require_relative 'helper'
require 'quotation'

describe Quotation do
  describe 'by default' do
    it 'quotes against the Euro' do
      quotation = Quotation.new
      rates = quotation.quote[:rates]
      rates.keys.wont_include 'EUR'
    end
  end

  describe 'when given a base' do
    it 'quotes against that base' do
      quotation = Quotation.new(base: 'USD')
      rates = quotation.quote[:rates]
      rates.keys.wont_include 'USD'
    end

    it 'sorts rates' do
      quotation = Quotation.new(base: 'USD')
      rates = quotation.quote[:rates]
      rates.keys.must_equal rates.keys.sort
    end
  end

  describe 'when given symbols' do
    it 'quotes rates only for given symbols' do
      quotation = Quotation.new(symbols: ['USD'])
      rates = quotation.quote[:rates]
      rates.keys.must_include 'USD'
      rates.keys.wont_include 'GBP'
    end
  end

  describe 'when given an amount' do
    it 'quotes for that amount' do
      quotation = Quotation.new(amount: 100)
      rates = quotation.quote[:rates]
      rates['USD'].must_be :>, 10
    end
  end

  describe 'when given an amount and symbols' do
    it 'quotes for that amount' do
      quotation = Quotation.new(amount: 100, symbols: ['USD'])
      rates = quotation.quote[:rates]
      rates['USD'].must_be :>, 10
    end
  end
end
