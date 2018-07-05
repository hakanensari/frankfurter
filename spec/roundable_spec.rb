# frozen_string_literal: true

require_relative 'helper'
require 'roundable'

describe Roundable do
  include Roundable

  it 'rounds values over 5,000 to zero decimal places' do
    round(5000.123456).must_equal 5000.0
  end

  it 'rounds values over 80 and below 5,000 to two decimal places' do
    round(80.123456).must_equal 80.12
    round(4999.123456).must_equal 4999.12
  end

  it 'rounds values over 20 and below 80 to three decimal places' do
    round(79.123456).must_equal 79.123
    round(20.123456).must_equal 20.123
  end

  it 'rounds values over 1 and below 20 to four decimal places' do
    round(19.123456).must_equal 19.1235
    round(1.123456).must_equal 1.1235
  end

  it 'rounds values below 1 to five decimal places' do
    round(0.123456).must_equal 0.12346
  end
end
