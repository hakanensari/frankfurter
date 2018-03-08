# frozen_string_literal: true

require 'currency'
require 'bank/feed'

module Bank
  def self.fetch_all_rates!
    Currency.db.transaction do
      Currency.dataset.delete
      Currency.multi_insert(Feed.historical.to_a)
    end
  end

  def self.fetch_current_rates!
    Currency.db.transaction do
      Feed.current.each do |hsh|
        Currency.find_or_create(hsh)
      end
    end
  end
end
