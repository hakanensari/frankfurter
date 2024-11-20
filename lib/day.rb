# frozen_string_literal: true

class Day < Sequel::Model
  dataset_module do
    def latest(date = Date.today)
      where(date: _nearest_date_with_rates(date))
    end

    def between(interval)
      return where(false) if interval.begin > Date.today

      where(Sequel.expr(:date) >= Sequel.function(
        :coalesce,
        _nearest_date_with_rates(interval.begin),
        interval.begin,
      ))
        .where(Sequel.expr(:date) <= interval.end)
    end

    def currencies
      select(
        :date,
        Sequel.lit("rates.key").as(:iso_code),
        Sequel.lit("rates.value::text::float").as(:rate),
      )
        .join(Sequel.function(:jsonb_each, :rates).lateral.as(:rates), true)
        .order(Sequel.asc(:date), Sequel.asc(Sequel.lit("rates.key")))
    end

    def _nearest_date_with_rates(date)
      select(:date)
        .where(Sequel[:date] <= date)
        .order(Sequel.desc(:date))
        .limit(1)
    end
  end
end
