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
        yield(date: Date.parse(day['time']),
              rates: day.nodes.each_with_object({}) do |currency, rates|
                rates[currency[:currency]] = Float(currency[:rate])
              end)
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
      URI("https://www.ecb.europa.eu/stats/eurofxref/eurofxref-#{@scope}.xml")
    end
  end
end
