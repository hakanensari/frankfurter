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
      feed.count.must_be :<, 40
    end

    it 'fetches rates for the past 90 days' do
      feed = Feed.ninety_days
      feed.count.must_be :>, 33 * 60
    end

    it 'fetches historical rates' do
      feed = Feed.historical
      feed.count.must_be :>, 33 * 3000
    end

    it 'parses the date of a currency' do
      feed = Feed.current
      currency = feed.first
      currency[:date].must_be_kind_of Date
    end

    it 'parse the ISO code of a currency' do
      feed = Feed.current
      currency = feed.first
      currency[:iso_code].must_be_kind_of String
    end

    it 'parses the rate of a currency' do
      feed = Feed.current
      currency = feed.first
      currency[:rate].must_be_kind_of Float
    end
  end
end
