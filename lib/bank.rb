# frozen_string_literal: true

require 'day'
require 'bank/feed'

module Bank
  class << self
    def fetch_all!
      data = Feed.historical.to_a
      jsonify!(data)
      Day.dataset.insert_conflict.multi_insert(data)
    end

    def fetch_ninety_days!
      data = Feed.ninety_days.to_a
      jsonify!(data)
      Day.dataset.insert_conflict.multi_insert(data)
    end

    def fetch_current!
      data = Feed.current.to_a
      jsonify!(data)
      Day.find_or_create(data.first)
    end

    def replace_all!
      data = Feed.historical.to_a
      jsonify!(data)
      Day.dataset.delete
      Day.multi_insert(data)
    end

    private

    def jsonify!(data)
      data.each do |day|
        day[:rates] = Sequel.pg_jsonb(day[:rates])
      end
    end
  end
end
