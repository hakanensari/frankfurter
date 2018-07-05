# frozen_string_literal: true

require_relative '../helper'
require 'quote/end_of_day'

module Quote
  describe EndOfDay do
    let(:date) do
      Date.parse('2010-10-10')
    end

    let(:quote) do
      EndOfDay.new(date: date)
    end

    before do
      quote.perform
    end

    it 'returns rates' do
      quote.formatted[:rates].wont_be :empty?
    end

    it 'quotes given date' do
      Date.parse(quote.formatted[:date]).must_be :<=, date
    end

    it 'quotes against the Euro' do
      quote.formatted[:rates].keys.wont_include 'EUR'
    end

    it 'sorts rates' do
      rates = quote.formatted[:rates]
      rates.keys.must_equal rates.keys.sort
    end

    it 'has a cache key' do
      quote.cache_key.wont_be :empty?
    end

    describe 'given a new base' do
      let(:quote) do
        EndOfDay.new(date: date, base: 'USD')
      end

      it 'quotes against that base' do
        quote.formatted[:rates].keys.wont_include 'USD'
      end

      it 'sorts rates' do
        rates = quote.formatted[:rates]
        rates.keys.must_equal rates.keys.sort
      end
    end

    describe 'given symbols' do
      let(:quote) do
        EndOfDay.new(date: date, symbols: %w[USD GBP JPY])
      end

      it 'quotes only for those symbols' do
        rates = quote.formatted[:rates]
        rates.keys.must_include 'USD'
        rates.keys.wont_include 'CAD'
      end

      it 'sorts rates' do
        rates = quote.formatted[:rates]
        rates.keys.must_equal rates.keys.sort
      end
    end

    describe 'when given an amount' do
      let(:quote) do
        EndOfDay.new(date: date, amount: 100)
      end

      it 'calculates quotes for that amount' do
        quote.formatted[:rates]['USD'].must_be :>, 10
      end
    end
  end
end
