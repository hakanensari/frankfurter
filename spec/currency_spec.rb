# frozen_string_literal: true

require_relative 'helper'
require 'currency'

describe Currency do
  around do |test|
    Currency.db.transaction do
      test.call
      raise Sequel::Rollback
    end
  end

  before do
    Currency.dataset.delete
    @earlier = [
      Currency.create(iso_code: 'EUR', rate: 1, date: '2014-01-01'),
      Currency.create(iso_code: 'USD', rate: 2, date: '2014-01-01')
    ]
    @later = [
      Currency.create(iso_code: 'EUR', rate: 1, date: '2015-01-01'),
      Currency.create(iso_code: 'USD', rate: 2, date: '2015-01-01')
    ]
  end

  it 'returns latest rates' do
    data = Currency.latest.to_a
    data.sample.date.must_equal @later.sample.date
  end

  it 'returns latest rates before given date' do
    data = Currency.latest(@later.sample.date - 1).to_a
    data.sample.date.must_equal @earlier.sample.date
  end

  it 'returns nothing if there are no rates before given date' do
    data = Currency.latest(@earlier.sample.date - 1).to_a
    data.must_be_empty
  end
end
