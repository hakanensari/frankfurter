# frozen_string_literal: true

class Day < Sequel::Model
  dataset_module do
    def latest(date = Date.today)
      where(date: select(:date).where(Sequel.lit('date <= ?', date))
                               .order(Sequel.desc(:date))
                               .limit(1))
    end

    def between(interval)
      where(date: interval)
    end

    def currencies
      select(:date,
             Sequel.lit('rates.key').as(:iso_code),
             Sequel.lit('rates.value::text::float').as(:rate))
        .join(Sequel.function(:jsonb_each, :rates).lateral.as(:rates), true)
    end
  end
end
