# frozen_string_literal: true

begin
  require "rubocop/rake_task"
rescue LoadError
  return
end

RuboCop::RakeTask.new
