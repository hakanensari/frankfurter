# frozen_string_literal: true

require_relative '../config/environment'

require 'minitest/autorun'
require 'minitest/around/spec'
require 'vcr'
require 'webmock'

begin
  require 'pry'
rescue LoadError # rubocop:disable Lint/HandleExceptions
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
end
