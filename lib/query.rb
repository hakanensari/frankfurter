# frozen_string_literal: true

class Query
  def initialize(params = {})
    @params = params
  end

  def amount
    return unless @params[:amount]

    @params[:amount].to_f
  end

  def base
    @params.values_at(:from, :base).compact.first&.upcase
  end

  def symbols
    @params.values_at(:to, :symbols).compact.first&.upcase&.split(',')
  end

  def date
    if @params[:date]
      Date.parse(@params[:date])
    else
      (Date.parse(@params[:start_date])..Date.parse(@params[:end_date]))
    end
  end

  def to_h
    { amount: amount, base: base, date: date, symbols: symbols }.compact
  end
end
