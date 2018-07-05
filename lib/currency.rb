# frozen_string_literal: true

class Currency < Sequel::Model
  dataset_module do
    def latest(date = Date.today)
      where(date: select(:date).where(Sequel.lit('date <= ?', date))
                               .order(Sequel.desc(:date))
                               .limit(1))
    end

    def between(date_interval)
      query = where(date: date_interval).order(:date)
      length = date_interval.last - date_interval.first
      if length > 365
        query.sampled('month')
      elsif length > 90
        query.sampled('week')
      else
        query
      end
    end

    def sampled(precision)
      sampled_date = Sequel.lit("date_trunc('#{precision}', date)")
      select(:iso_code).select_append { avg(rate).as(rate) }
                       .select_append(sampled_date.as(:date))
                       .group(:iso_code, sampled_date)
    end
  end
end
