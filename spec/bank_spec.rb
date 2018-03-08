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
    Currency.dataset.delete
  end

  after do
    VCR.eject_cassette
  end

  it 'fetches all rates' do
    Bank.fetch_all_rates!
    Currency.count.must_be :positive?
  end

  it 'fetches current rates' do
    Bank.fetch_current_rates!
    Currency.count.must_be :positive?
  end
end
