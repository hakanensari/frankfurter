# frozen_string_literal: true

class Currency < Sequel::Model
  dataset_module do
    def latest(date = Date.today)
      where(date: select(:date).where(Sequel.lit('date <= ?', date))
                               .order(Sequel.desc(:date))
                               .limit(1))
    end
  end
end
