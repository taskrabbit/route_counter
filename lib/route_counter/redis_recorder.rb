require 'fileutils'
require 'monitor'

# A recorder implements these class methods
#   * action_visited(controller_name, action_name) : record that it was visited
#   * actions_visited : returns hash of url => count
#   * rotate! : backup what was recorded and start counting again. returns hash.
#   * clear!  : clear everything out

module RouteCounter
  class RedisRecorder
    class << self

      def client
        RouteCounter.config.redis
      end

      def current_key
        "route_counter:current"
      end

      def read_key(key)
        out = {}
        client.hgetall(key).each do |action, num|
          out[action] = num.to_i
        end
        out
      end

      def increment!(action_key, amount)
        client.hincrby(current_key, action_key, amount)
      end

      def action_visited(controller_name, action_name)
        key = "#{controller_name}##{action_name}"
        increment!(key, 1)
      end

      def actions_visited
        # returns what was visited and counts
        read_key(current_key)
      end

      def rotate!
        raise "not supported"
      end

      def clear!
        client.del(current_key)
      end
    end
  end
end