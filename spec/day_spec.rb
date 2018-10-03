# frozen_string_literal: true

require_relative 'helper'
require 'day'

describe Day do
  describe '.latest' do
    it 'returns latest rates before given date' do
      date = Date.parse('2010-01-01')
      data = Day.latest(date)
      data.first.date.must_be :<=, date
    end

    it 'returns nothing if there are no rates before given date' do
      Day.latest(Date.parse('1998-01-01')).must_be_empty
    end
  end

  describe '.between' do
    it 'returns rates between given dates' do
      start_date = Date.parse('2010-01-01')
      end_date = Date.parse('2010-01-31')
      dates = Day.between((start_date..end_date)).map(:date).sort
      dates.first.must_be :>=, start_date
      dates.last.must_be :<=, end_date
    end

    it 'returns nothing if there are no rates between given dates' do
      interval = (Date.parse('1998-01-01')..Date.parse('1998-01-31'))
      Day.between(interval).must_be_empty
    end
  end
end
