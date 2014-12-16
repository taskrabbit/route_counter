module RouteCounter
  class Config
    attr_writer :directory, :enabled

    def directory
      @directory ||= Dir.home
    end

    def enabled
      !!@enabled
    end
    alias :enabled? :enabled

  end
end