# frozen_string_literal: true

require_relative 'helper'
require 'currency_names'

describe CurrencyNames do
  let(:currency_names) do
    CurrencyNames.new
  end

  it 'returns currency codes and names' do
    currency_names.formatted['USD'].must_equal 'United States Dollar'
  end

  it 'has a cache key' do
    currency_names.cache_key.wont_be :empty?
  end
end
