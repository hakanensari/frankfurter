# frozen_string_literal: true

require "./config/environment"
require "web/server"

run Web::Server.freeze.app
