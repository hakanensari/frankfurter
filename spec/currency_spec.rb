# frozen_string_literal: true

require_relative 'helper'
require 'currency'

describe Currency do
  describe '.latest' do
    it 'returns latest rates' do
      data = Currency.latest.all
      data.count.must_be :>, 1
    end
  end

  describe '.between' do
    let(:day) do
      Date.parse('2010-01-01')
    end

    it 'returns everything up to 90 days' do
      interval = day..day + 90
      Currency.between(interval).map(:date).uniq.count.must_be :>, 30
    end

    it 'samples weekly over 90 but below 366 days' do
      interval = day..day + 365
      Currency.between(interval).map(:date).uniq.count.must_be :<=, 52
    end

    it 'samples monthly over 365 days' do
      interval = day..day + 400
      Currency.between(interval).map(:date).uniq.count.must_be :<=, 120
    end

    it 'sorts by date' do
      interval = day..day + 100
      dates = Currency.between(interval).map(:date)
      dates.must_equal dates.sort
    end
  end

  describe '.only' do
    it 'filters symbols' do
      iso_codes = %w[CAD USD]
      data = Currency.latest.only(*iso_codes).all
      data.map(&:iso_code).sort.must_equal iso_codes
    end

    it 'returns nothing if no matches' do
      Currency.only('FOO').all.must_be_empty
    end
  end
end
