# frozen_string_literal: true

namespace :rates do
  desc 'Load all'
  task all: :environment do
    require 'bank'
    Bank.fetch_all!
  end

  desc 'Load last 90 days'
  task ninety_days: :environment do
    require 'bank'
    Bank.fetch_ninety_days!
  end

  desc 'Load current'
  task current: :environment do
    require 'bank'
    Bank.fetch_current!
  end
end
