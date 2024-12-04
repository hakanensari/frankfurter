# frozen_string_literal: true

require "rake/testtask"

Rake::TestTask.new(:spec) do |t|
  t.test_files = FileList["spec/**/*_spec.rb"]
end
