# frozen_string_literal: true

require "rake/testtask"
begin
  require "rubocop/rake_task"
rescue LoadError
  return
end

Rake::TestTask.new(spec: :environment) do |t|
  t.libs << "lib"
  t.libs << "test"
  t.test_files = FileList["spec/**/*_spec.rb"]
end

RuboCop::RakeTask.new

task default: ["rubocop", "db:test:prepare", "spec"]
