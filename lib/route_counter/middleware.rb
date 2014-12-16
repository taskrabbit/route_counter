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
      # TODO: case on config for types: file, redis, other
      # TODO: maybe send if POST, GET, ETC (other info?)
      RouteCounter::FileRecorder.path_visited(path)
    rescue Exception => e
      RouteCounter.config.error!("[RouteCleaner] #{e.message}\n#{e.backtrace.join("\n")}")
    end
  end
end
