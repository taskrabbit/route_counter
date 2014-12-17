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
        count_width, name_width, verb_width, path_width = widths(routes)

        routes.map do |r|
          "#{count_for_route(r).ljust(count_width)} #{r[:name].ljust(name_width)} #{r[:verb].ljust(verb_width)} #{r[:path].ljust(path_width)} #{r[:reqs]}"
        end
      end

      def draw_header(routes)
        count_width, name_width, verb_width, path_width = widths(routes)

        "#{"Count".rjust(count_width)} #{"Prefix".ljust(name_width)} #{"Verb".ljust(verb_width)} #{"URI Pattern".ljust(path_width)} Controller#Action"
      end

      def widths(routes)
        [ max_count_width,
         routes.map { |r| r[:name].length }.max,
         routes.map { |r| r[:verb].length }.max,
         routes.map { |r| r[:path].length }.max]
      end

      def max_count_width
        @max_count_width ||= [@path_hash.values.max.to_s.length, "Count".length].max
      end

      def count_for_route(r)
        regex = Regexp.new(r[:regexp])
        count = 0
        @path_hash.each do |url, num|
          next unless url =~ regex
          count += num
        end
        count.to_s
      end
  end
end
