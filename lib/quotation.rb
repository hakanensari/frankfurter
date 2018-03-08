# frozen_string_literal: true

require 'currency'

class Quotation
  DEFAULT_BASE = 'EUR'

  def initialize(amount: 1.0,
                 base: DEFAULT_BASE,
                 date: Date.today.to_s,
                 symbols: nil)
    @amount = amount
    @base = base
    @date = date
    @symbols = symbols
  end

  def quote
    { date: date, rates: calculate_rates }
  end

  def date
    currencies.first[:date].to_s
  end

  private

  def calculate_rates # rubocop:disable Metrics/AbcSize
    rates = currencies.each_with_object({}) do |currency, hsh|
      hsh[currency[:iso_code]] = currency[:rate]
    end

    return rates if @base == DEFAULT_BASE && @amount == 1.0

    if @symbols.nil? || @symbols.include?(DEFAULT_BASE)
      rates.update(DEFAULT_BASE => 1.0)
    end
    divisor = rates.delete(@base)

    rates.sort.map! { |ic, rate| [ic, round(@amount * rate / divisor)] }.to_h
  end

  def currencies
    @currencies ||= begin
      scope = Currency.latest(@date)
      scope = scope.where(iso_code: @symbols + [@base]) if @symbols

      scope.order(:iso_code).naked
    end
  end

  # To paraphrase Wikipedia, most currency pairs are quoted to four decimal
  # places. An exception to this is exchange rates with a value of less than
  # 1.000, which are quoted to five or six decimal places. Exchange rates
  # greater than around 20 are usually quoted to three decimal places and
  # exchange rates greater than 80 are quoted to two decimal places.
  # Currencies over 5000 are usually quoted with no decimal places.
  def round(rate)
    Float(format('%.5g', rate))
  end
end
