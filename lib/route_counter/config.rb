module RouteCounter
  class Config
    attr_writer :directory

    def directory
      @directory ||= Dir.home
    end

  end
end