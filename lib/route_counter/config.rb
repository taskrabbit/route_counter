module RouteCounter
  class Config
    attr_writer :directory, :enabled

    def directory
      @directory ||= File.join(Dir.home, "route_counter")
    end

    def enabled
      !!@enabled
    end
    alias :enabled? :enabled

    def error!(e)
      # TODO: not worth it to crash but should log. allow settable
      if defined?(Rails)
        Rails.logger.error(e)
      end
    end
  end
end