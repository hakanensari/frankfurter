# frozen_string_literal: true

ENV['APP_ENV'] ||= 'test'

# Keep SimpleCov at top.
require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
end

require_relative '../config/environment'

require 'minitest/autorun'
require 'minitest/around/spec'
require 'minitest/focus'
require 'vcr'
require 'webmock'

begin
  require 'pry'
rescue LoadError # rubocop:disable Lint/SuppressedException
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.hook_into :webmock
end
