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
  
  config.after(:each) do
    RouteCounter.send(:reset)
  end

end