# frozen_string_literal: true

require_relative 'helper'
require 'bank'

describe Bank do
  around do |test|
    Currency.db.transaction do
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
    Currency.dataset.delete
    Bank.fetch_all_rates!
    Currency.count.must_be :positive?
  end

  it 'skips existing records when fetching all rates' do
    Currency.where { date < '2012-01-01' }.delete
    Bank.fetch_all_rates!
    Currency.where { date < '2012-01-01' }.count.must_be :positive?
  end

  it 'fetches current rates' do
    Currency.dataset.delete
    Bank.fetch_current_rates!
    Currency.count.must_be :positive?
  end

  it 'replaces all rates' do
    Currency.dataset.delete
    Bank.fetch_all_rates!
    Currency.count.must_be :positive?
  end
end
