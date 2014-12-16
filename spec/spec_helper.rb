require 'route_counter'

RSpec.configure do |config|
  config.mock_framework = :rspec
  
  config.after(:each) do
    RouteCounter.send(:reset)
  end

end