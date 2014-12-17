module RouteCounter
  class Middleware
    attr_reader :env
    def initialize(app)
      @app = app
    end

    def call(env)
      @env = env
      status, headers, body = @app.call(env)
      write_result! if RouteCounter.config.enabled?
      [status, headers, body]
    end

    def write_result!
      result = env['action_dispatch.request.path_parameters']
      return unless result

      controller_name = result[:controller]
      action_name     = result[:action]

      return unless controller_name && action_name

      # TODO: case on config for types: file, redis, other
      # TODO: use env['REQUEST_METHOD'] ?
      RouteCounter::FileRecorder.action_visited(controller_name, action_name)
    rescue Exception => e
      RouteCounter.config.error!("[RouteCleaner] #{e.message}\n#{e.backtrace.join("\n")}")
    end
  end
end
