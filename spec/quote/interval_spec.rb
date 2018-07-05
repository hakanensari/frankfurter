# frozen_string_literal: true

require_relative '../helper'
require 'quote/interval'

module Quote
  describe Interval do
    let(:date_interval) do
      (Date.parse('2010-01-01')..Date.parse('2010-12-31'))
    end

    let(:quote) do
      Interval.new(date: date_interval)
    end

    before do
      quote.perform
    end

    it 'returns rates' do
      quote.formatted[:rates].wont_be :empty?
    end

    it 'quotes given date interval' do
      Date.parse(quote.formatted[:start_date]).must_be :>=, date_interval.first
      Date.parse(quote.formatted[:end_date]).must_be :<=, date_interval.last
    end

    it 'quotes against the Euro' do
      quote.formatted[:rates].each_value do |rates|
        rates.keys.wont_include 'EUR'
      end
    end

    it 'sorts rates' do
      quote.formatted[:rates].each_value do |rates|
        rates.keys.must_equal rates.keys.sort
      end
    end

    it 'has a cache key' do
      quote.cache_key.wont_be :empty?
    end

    describe 'given a new base' do
      let(:quote) do
        Interval.new(date: date_interval, base: 'USD')
      end

      it 'quotes against that base' do
        quote.formatted[:rates].each_value do |rates|
          rates.keys.wont_include 'USD'
        end
      end

      it 'sorts rates' do
        quote.formatted[:rates].each_value do |rates|
          rates.keys.must_equal rates.keys.sort
        end
      end
    end

    describe 'given symbols' do
      let(:quote) do
        Interval.new(date: date_interval, symbols: %w[USD GBP JPY])
      end

      it 'quotes only for those symbols' do
        quote.formatted[:rates].each_value do |rates|
          rates.keys.must_include 'USD'
          rates.keys.wont_include 'CAD'
        end
      end

      it 'sorts rates' do
        quote.formatted[:rates].each_value do |rates|
          rates.keys.must_equal rates.keys.sort
        end
      end
    end

    describe 'when given an amount' do
      let(:quote) do
        Interval.new(date: date_interval, amount: 100)
      end

      it 'calculates quotes for that amount' do
        quote.formatted[:rates].each_value do |rates|
          rates['USD'].must_be :>, 10
        end
      end
    end
  end
end
