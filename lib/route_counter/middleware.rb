module RouteCounter
  class Middleware
    attr_reader :env
    def initialize(app)
      @app = app
    end

    def call(env)
      @env = env
      write_path! if RouteCounter.config.enabled?
      @app.call(env)
    end

    def write_path!
      path = RouteCounter::Util.normalize_path(env['PATH_INFO'])
      puts "RouteCounter: #{path}"
    end
  end
end
