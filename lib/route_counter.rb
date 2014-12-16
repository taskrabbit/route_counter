require "route_counter/version"

module RouteCounter
  autoload :Config, 'route_counter/config'

  class << self
    def config
      @config ||= RouteCounter::Config.new
    end

    protected

    def reset
      # mostly for tests, resets eveything
      @config = nil
    end
  end
end
