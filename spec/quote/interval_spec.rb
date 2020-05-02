# frozen_string_literal: true

require_relative '../helper'
require 'quote/interval'

module Quote
  describe Interval do
    let(:dates) do
      (Date.parse('2010-01-01')..Date.parse('2010-12-31'))
    end

    let(:quote) do
      Interval.new(date: dates)
    end

    before do
      quote.perform
    end

    it 'returns rates' do
      _(quote.formatted[:rates]).wont_be :empty?
    end

    it 'quotes given date interval' do
      _(Date.parse(quote.formatted[:start_date])).must_be :>=, dates.first
      _(Date.parse(quote.formatted[:end_date])).must_be :<=, dates.last
    end

    it 'quotes against the Euro' do
      quote.formatted[:rates].each_value do |rates|
        _(rates.keys).wont_include 'EUR'
      end
    end

    it 'sorts rates' do
      quote.formatted[:rates].each_value do |rates|
        _(rates.keys).must_equal rates.keys.sort
      end
    end

    it 'has a cache key' do
      _(quote.cache_key).wont_be :empty?
    end

    describe 'given a new base' do
      let(:quote) do
        Interval.new(date: dates, base: 'USD')
      end

      it 'quotes against that base' do
        quote.formatted[:rates].each_value do |rates|
          _(rates.keys).wont_include 'USD'
        end
      end

      it 'sorts rates' do
        quote.formatted[:rates].each_value do |rates|
          _(rates.keys).must_equal rates.keys.sort
        end
      end
    end

    describe 'given symbols' do
      let(:quote) do
        Interval.new(date: dates, symbols: %w[USD GBP JPY])
      end

      it 'quotes only for those symbols' do
        quote.formatted[:rates].each_value do |rates|
          _(rates.keys).must_include 'USD'
          _(rates.keys).wont_include 'CAD'
        end
      end

      it 'sorts rates' do
        quote.formatted[:rates].each_value do |rates|
          _(rates.keys).must_equal rates.keys.sort
        end
      end
    end

    describe 'when given an amount' do
      let(:quote) do
        Interval.new(date: dates, amount: 100)
      end

      it 'calculates quotes for that amount' do
        quote.formatted[:rates].each_value do |rates|
          _(rates['USD']).must_be :>, 10
        end
      end
    end
  end
end
