require 'route_counter'

begin
  require 'byebug'

  module Kernel
    alias :debugger :byebug
  end

rescue LoadError => e
  # byebug isn't installed - no debugging here!
end


RSpec.configure do |config|
  config.mock_framework = :rspec
  
  config.before(:each) do
    RouteCounter.send(:reset)
    RouteCounter.config.directory = File.expand_path("tmp/recorder")
  end
end