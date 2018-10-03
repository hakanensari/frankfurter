# frozen_string_literal: true

require_relative '../helper'
require 'bank/feed'

module Bank
  describe Feed do
    before do
      VCR.insert_cassette 'feed'
    end

    after do
      VCR.eject_cassette
    end

    it 'fetches current rates' do
      feed = Feed.current
      feed.count.must_be :==, 1
    end

    it 'fetches rates for the past 90 days' do
      feed = Feed.ninety_days
      feed.count.must_be :>, 1
      feed.count.must_be :<=, 90
    end

    it 'fetches historical rates' do
      feed = Feed.historical
      feed.count.must_be :>, 90
    end

    it 'parses dates' do
      feed = Feed.current
      day = feed.first
      day[:date].must_be_kind_of Date
    end

    it 'parses rates' do
      feed = Feed.current
      day = feed.first
      day[:rates].each do |iso_code, value|
        iso_code.must_be_kind_of String
        value.must_be_kind_of Float
      end
    end
  end
end
