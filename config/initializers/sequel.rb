# frozen_string_literal: true

require 'pg'
require 'sequel'

Sequel.extension :pg_json_ops
Sequel.single_threaded = true
Sequel.connect(ENV['DATABASE_URL'] ||
              "postgres://#{ENV['POSTGRES_USER']}:#{ENV['POSTGRES_PASSWORD']}@localhost/#{ENV['POSTGRES_DB']}")
      .extension :pg_json
