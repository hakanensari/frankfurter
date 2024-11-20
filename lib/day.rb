# frozen_string_literal: true

class Day < Sequel::Model
  dataset_module do
    def latest(date = Date.today)
      where(date: select(:date).where(Sequel[:date] <= date)
                               .order(Sequel.desc(:date))
                               .limit(1))
    end

    # Returns rates for a given date interval
    #
    # If the start date falls on a holiday/weekend, rates start from the closest preceding business day.
    def between(interval)
      return where(false) if interval.begin > Date.today

      previous_date = select(:date)
        .where(Sequel[:date] <= interval.begin)
        .order(Sequel.desc(:date))
        .limit(1)

      where(Sequel.expr(:date) >= Sequel.function(:coalesce, previous_date, interval.begin))
        .where(Sequel.expr(:date) <= interval.end)
    end

    def currencies
      select(
        :date,
        Sequel.lit("rates.key").as(:iso_code),
        Sequel.lit("rates.value::text::float").as(:rate),
      )
        .join(Sequel.function(:jsonb_each, :rates).lateral.as(:rates), true)
    end
  end
end
