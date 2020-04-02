# frozen_string_literal: true

require 'day'
require 'forwardable'

class Currency < Sequel::Model(Day.currencies)
  class << self
    extend Forwardable

    def_delegators :dataset, :latest, :between
  end

  dataset_module do
    def only(*iso_codes)
      where(iso_code: iso_codes)
    end

    def between(interval)
      case interval.last - interval.first
      when 91.. then super.sample('week')
      else super
      end
    end

    def sample(precision)
      sampler = Sequel.function(:date_trunc, precision, :date)

      select(:iso_code)
        .select_append { avg(rate).as(rate) }
        .select_append(sampler.as(:date))
        .group(:iso_code, sampler)
        .order(:date)
    end
  end
end
