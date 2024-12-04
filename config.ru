# frozen_string_literal: true

ENV["APP_ENV"] ||= "development"

$LOAD_PATH << File.expand_path("lib", __dir__)
require "web/server"

run Web::Server.freeze.app
