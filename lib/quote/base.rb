# frozen_string_literal: true

require 'roundable'

module Quote
  class Base
    include Roundable

    DEFAULT_BASE = 'EUR'

    attr_reader :amount, :base, :date, :symbols, :result

    def initialize(date:, amount: 1.0, base: 'EUR', symbols: nil)
      @date = date
      @amount = amount
      @base = base
      @symbols = symbols
      @result = {}
    end

    def perform
      return false if result.frozen?

      prepare_rates
      rebase_rates if must_rebase?
      result.freeze

      true
    end

    def must_rebase?
      base != 'EUR'
    end

    def formatted
      raise NotImplementedError
    end

    def not_found?
      result.empty?
    end

    def cache_key
      raise NotImplementedError
    end

    private

    def data
      @data ||= fetch_data
    end

    def fetch_data
      raise NotImplementedError
    end

    def prepare_rates
      data.each_with_object(result) do |currency, result|
        date = currency[:date].to_date.to_s
        result[date] ||= {}
        result[date][currency[:iso_code]] = round(amount * currency[:rate])
      end
    end

    def rebase_rates
      result.each do |date, rates|
        add_euro(rates)

        divisor = rates.delete(base)
        result[date] = rates.sort
                            .map! do |iso_code, rate|
                              [iso_code, round(amount * rate / divisor)]
                            end
                            .to_h
      end
    end

    def add_euro(rates)
      rates['EUR'] = amount if symbols.nil? || symbols.include?('EUR')
    end
  end
end
