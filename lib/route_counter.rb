require "route_counter/version"

module RouteCounter
  autoload :Config,           'route_counter/config'
  autoload :ConsoleFormatter, 'route_counter/console_formatter'
  autoload :FileRecorder,     'route_counter/file_recorder'
  autoload :Middleware,       'route_counter/middleware'
  autoload :RedisRecorder,    'route_counter/redis_recorder'
  autoload :Snapshot,         'route_counter/snapshot'
  autoload :Util,             'route_counter/util'

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
