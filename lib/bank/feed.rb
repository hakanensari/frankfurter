# frozen_string_literal: true

require 'net/http'
require 'ox'

module Bank
  class Feed
    include Enumerable

    def self.current
      url = URI('https://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml')
      xml = Net::HTTP.get(url)

      new(xml)
    end

    def self.ninety_days
      url = URI('https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml')
      xml = Net::HTTP.get(url)

      new(xml)
    end

    def self.historical
      url = URI('https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist.xml')
      xml = Net::HTTP.get(url)

      new(xml)
    end

    def self.saved_data
      xml = File.read(File.join(__dir__, 'eurofxref-hist.xml'))
      new(xml)
    end

    def initialize(xml)
      @document = Ox.load(xml)
    end

    def each
      @document.locate('gesmes:Envelope/Cube/Cube').each do |day|
        yield(date: Date.parse(day['time']),
              rates: day.nodes.each_with_object({}) do |currency, rates|
                rates[currency[:currency]] = Float(currency[:rate])
              end)
      end
    end
  end
end
