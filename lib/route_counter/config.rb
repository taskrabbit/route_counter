module RouteCounter
  class Config
    attr_writer :directory, :enabled, :redis

    def directory
      @directory ||= File.join(Dir.home, "route_counter")
    end

    def enabled
      !!@enabled
    end
    alias :enabled? :enabled

    def redis
      return @redis if @redis
      require 'redis'
      @redis = Redis.new
    end

    def error!(e)
      # TODO: not worth it to crash but should log. allow settable
      if defined?(Rails)
        Rails.logger.error(e)
      end
    end
  end
end