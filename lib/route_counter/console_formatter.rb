require 'action_dispatch/routing/inspector'

module RouteCounter
  class ConsoleFormatter # like ActionDispatch::Routing::ConsoleFormatter
    class << self
      def puts!(recorder_klass)
        # from railties/routes.rake
        all_routes = Rails.application.routes.routes
        inspector = ActionDispatch::Routing::RoutesInspector.new(all_routes)
        path_hash = recorder_klass.paths_visited
        formatter = RouteCounter::ConsoleFormatter.new(path_hash)
        puts inspector.format(formatter, ENV['CONTROLLER'])
      end
    end

    def initialize(path_hash)
      @buffer = []
      @path_hash = path_hash || {}
    end

    def result
      @buffer.join("\n")
    end

    def section_title(title)
      @buffer << "\n#{title}:"
    end

    def section(routes)
      @buffer << draw_section(routes)
    end

    def header(routes)
      @buffer << draw_header(routes)
    end

    def no_routes
      @buffer << <<-MESSAGE.strip_heredoc
        You don't have any routes defined!

        Please add some routes in config/routes.rb.

        For more information about routes, see the Rails guide: http://guides.rubyonrails.org/routing.html.
        MESSAGE
    end

    private
      def draw_section(routes)
        name_width, verb_width, path_width = widths(routes)

        routes.map do |r|
          "#{r[:name].rjust(name_width)} #{r[:verb].ljust(verb_width)} #{r[:path].ljust(path_width)} #{r[:reqs]}"
        end
      end

      def draw_header(routes)
        name_width, verb_width, path_width = widths(routes)

        "#{"Prefix".rjust(name_width)} #{"Verb".ljust(verb_width)} #{"URI Pattern".ljust(path_width)} Controller#Action"
      end

      def widths(routes)
        [routes.map { |r| r[:name].length }.max,
         routes.map { |r| r[:verb].length }.max,
         routes.map { |r| r[:path].length }.max]
      end
  end
end
