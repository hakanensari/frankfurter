# frozen_string_literal: true

require 'net/http'
require 'ox'

module Bank
  class Feed
    include Enumerable

    def self.current
      new('daily')
    end

    def self.ninety_days
      new('hist-90d')
    end

    def self.historical
      new('hist')
    end

    def initialize(scope)
      @scope = scope
    end

    def each
      document.locate('gesmes:Envelope/Cube/Cube').each do |day|
        date = Date.parse(day['time'])
        day.locate('Cube').each do |record|
          yield(
            date: date,
            iso_code: record['currency'],
            rate: Float(record['rate'])
          )
        end
      end
    end

    private

    def document
      Ox.load(xml)
    end

    def xml
      Net::HTTP.get(url)
    end

    def url
      URI("http://www.ecb.europa.eu/stats/eurofxref/eurofxref-#{@scope}.xml")
    end
  end
end
