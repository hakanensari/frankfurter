# frozen_string_literal: true

desc 'Load environment'
task :environment do
  require './config/environment'
end
