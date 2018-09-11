# frozen_string_literal: true

require 'currency'
require 'quote/base'

module Quote
  class EndOfDay < Base
    def formatted
      { amount: amount,
        base: base,
        date: result.keys.first,
        rates: result.values.first }
    end

    def cache_key
      return if not_found?

      Digest::MD5.hexdigest(result.keys.first)
    end

    private

    def fetch_data
      scope = Currency.latest(date)
      scope = scope.where(iso_code: symbols + [base]) if symbols

      scope.naked
    end
  end
end
