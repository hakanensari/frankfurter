# frozen_string_literal: true

source 'https://rubygems.org'

ruby File.read('.ruby-version').chomp

gem 'dotenv-rails'
gem 'money'
gem 'newrelic_rpm'
gem 'oj'
gem 'ox'
gem 'rack-contrib'
gem 'rack-cors'
gem 'rake'
gem 'roda'
gem 'rufus-scheduler'
gem 'scout_apm'
gem 'sequel'
gem 'sqlite3'
gem 'unicorn'

group :development, :test do
  gem 'pry-byebug'
  gem 'rubocop-minitest'
  gem 'rubocop-performance'
  gem 'rubocop-rake'
  gem 'rubocop-sequel'
end

group :test do
  gem 'minitest'
  gem 'minitest-around'
  gem 'minitest-focus'
  gem 'rack-test'
  gem 'simplecov'
  gem 'vcr'
  gem 'webmock'
end
