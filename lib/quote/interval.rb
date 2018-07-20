# frozen_string_literal: true

require 'currency'
require 'quote/base'

module Quote
  class Interval < Base
    def formatted
      { amount: amount,
        base: base,
        start_date: result.keys.first,
        end_date: result.keys.last,
        rates: result }
    end

    def cache_key
      return if not_found?
      Digest::MD5.hexdigest(result.keys.last)
    end

    private

    def fetch_data
      scope = Currency.between(date)
      scope = scope.where(iso_code: symbols + [base]) if symbols

      scope.naked
    end
  end
end
