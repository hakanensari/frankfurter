# frozen_string_literal: true

desc "Load environment"
task :environment do
  $LOAD_PATH << File.expand_path("..", __dir__)
end
