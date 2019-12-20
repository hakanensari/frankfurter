# frozen_string_literal: true

require_relative 'app'
$LOAD_PATH << App.root.join('lib')
Dir[App.root.join('config/initializers/*.rb')].sort.each { |f| require f }
