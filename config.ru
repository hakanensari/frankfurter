# frozen_string_literal: true

require_relative "boot"
require "web/server"

run Web::Server.freeze.app
