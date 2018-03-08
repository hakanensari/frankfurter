# frozen_string_literal: true

class Query
  def initialize(params = {})
    @params = params
  end

  def amount
    @params[:amount].to_f if @params[:amount] # rubocop:disable Style/SafeNavigation
  end

  def base
    @params.values_at(:base, :from).compact.first&.upcase
  end

  def symbols
    @params.values_at(:symbols, :to).compact.first&.split(',')
  end

  def date
    @params[:date]
  end

  def to_h
    { amount: amount, base: base, date: date, symbols: symbols }.compact
  end
end
