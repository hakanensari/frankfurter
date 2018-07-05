# frozen_string_literal: true

require_relative 'helper'
require 'currency'

describe Currency do
  describe '.current' do
    it 'returns current rates' do
      date = Currency.order(Sequel.desc(:date)).first.date
      rates = Currency.latest
      rates.first.date.must_equal date
    end

    it 'returns latest rates before given date' do
      date = Date.parse('2010-01-01')
      rates = Currency.latest(date)
      rates.first.date.must_be :<=, date
    end

    it 'returns nothing if there are no rates before given date' do
      rates = Currency.latest(Date.parse('1998-01-01'))
      rates.must_be_empty
    end
  end

  describe '.between' do
    it 'returns rates between given dates' do
      start_date = Date.parse('2010-01-01')
      end_date = Date.parse('2010-01-31')
      dates = Currency.between((start_date..end_date)).map(:date).uniq.sort
      dates.first.must_be :>=, start_date
      dates.last.must_be :<=, end_date
    end

    it 'returns nothing if there are no rates between given dates' do
      date_interval = (Date.parse('1998-01-01')..Date.parse('1998-01-31'))
      Currency.between(date_interval).must_be_empty
    end

    it 'returns all rates up to 90 days' do
      date_interval = (Date.parse('2010-01-01')..Date.parse('2010-03-01'))
      Currency.between(date_interval).map(:date).uniq.count.must_be :>, 30
    end

    it 'samples weeks over 90 days and below 366 days' do
      date_interval = (Date.parse('2010-01-01')..Date.parse('2010-12-31'))
      Currency.between(date_interval).map(:date).uniq.count.must_be :<=, 52
    end

    it 'samples months over 365 days' do
      date_interval = (Date.parse('2001-01-01')..Date.parse('2010-12-31'))
      Currency.between(date_interval).map(:date).uniq.count.must_be :<=, 120
    end
  end
end
