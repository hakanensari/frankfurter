# frozen_string_literal: true

require 'sequel'

Sequel.sqlite(ENV['SQLITE_DB'])
