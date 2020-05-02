# frozen_string_literal: true

require_relative 'helper'
require 'bank'

describe Bank do
  around do |test|
    Day.db.transaction do
      Day.dataset.delete
      test.call
      raise Sequel::Rollback
    end
  end

  before do
    VCR.insert_cassette 'feed'
  end

  after do
    VCR.eject_cassette
  end

  it 'fetches all rates' do
    Bank.fetch_all!
    _(Day.count).must_be :>, 90
  end

  it 'does not duplicate when fetching all rates' do
    Bank.fetch_all!
    count = Day.count
    Bank.fetch_all!
    _(Day.count).must_equal count
  end

  it 'fetches rates for last 90 days' do
    Bank.fetch_ninety_days!
    _(Day.count).must_be :>, 1
    _(Day.count).must_be :<, 90
  end

  it 'seeds rates with saved data' do
    Bank.seed_with_saved_data!
    _(Day.count).must_be :>, 90
  end

  it 'does not duplicate when fetching rates for last 90 days' do
    Bank.fetch_ninety_days!
    count = Day.count
    Bank.fetch_ninety_days!
    _(Day.count).must_equal count
  end

  it 'fetches current rates' do
    Bank.fetch_current!
    _(Day.count).must_equal 1
  end

  it 'does not duplicate when fetching current rates' do
    2.times { Bank.fetch_current! }
    _(Day.count).must_equal 1
  end

  it 'replaces all rates' do
    Bank.replace_all!
    _(Day.count).must_be :>, 90
  end
end
