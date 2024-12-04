# frozen_string_literal: true

require "sequel"

Sequel.connect("sqlite://#{Dir.pwd}/db/frankfurter.sqlite3")
