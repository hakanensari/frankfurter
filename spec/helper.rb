# frozen_string_literal: true

ENV["APP_ENV"] ||= "test"

require_relative "../config/environment"

require "minitest/autorun"
require "minitest/around/spec"
require "minitest/focus"
require "vcr"
require "webmock"

VCR.configure do |c|
  c.cassette_library_dir = "spec/vcr_cassettes"
  c.hook_into(:webmock)
end
