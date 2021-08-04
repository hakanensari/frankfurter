# frozen_string_literal: true

require 'dotenv/load'

desc 'Load environment'
task :environment do
  require './config/environment'
end
