# frozen_string_literal: true

require_relative 'helper'
require 'bank'

describe Bank do
  around do |test|
    Day.db.transaction do
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
    Day.dataset.delete
    Bank.fetch_all!
    Day.count.must_be :positive?
  end

  it 'skips existing records when fetching all rates' do
    Day.where { date < '2012-01-01' }.delete
    Bank.fetch_all!
    Day.where { date < '2012-01-01' }.count.must_be :positive?
  end

  it 'fetches rates for last 90 days' do
    Day.dataset.delete
    Bank.fetch_ninety_days!
    Day.count.must_be :positive?
  end

  it 'skips existing records when fetching rates for last 90 days' do
    cutoff = Date.today - 60
    Day.where { date < cutoff }.delete
    Bank.fetch_ninety_days!
    Day.where { date < cutoff }.count.must_be :positive?
  end

  it 'fetches current rates' do
    Day.dataset.delete
    Bank.fetch_current!
    Day.count.must_be :positive?
  end

  it 'replaces all rates' do
    Day.dataset.delete
    Bank.fetch_all!
    Day.count.must_be :positive?
  end
end
