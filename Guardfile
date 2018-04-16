# frozen_string_literal: true

guard 'livereload' do
  extensions = %i[css js png gif jpg]
  watch(%r{lib/web/public/.+\.(#{extensions * '|'})})
  watch(%r{lib/web/views/.+\.erb$})
end

guard :minitest do
  watch(%r{^spec/(.*)_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})    { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^spec/helper\.rb$}) { 'spec' }
end
