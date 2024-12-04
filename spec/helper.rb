# frozen_string_literal: true

ENV["APP_ENV"] ||= "test"
$LOAD_PATH << File.expand_path("../lib", __dir__)

require "minitest/autorun"
require "minitest/around/spec"
require "minitest/focus"
require "vcr"
require "webmock"

VCR.configure do |c|
  c.cassette_library_dir = "spec/vcr_cassettes"
  c.hook_into(:webmock)
end
