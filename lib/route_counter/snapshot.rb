module RouteCounter
  class Snapshot
    class << self
      # send to redis
      def transfer!(recorder_klass)
        hash = recorder_klass.rotate!
        hash.each do |action, num|
          RedisRecorder.increment!(action, num)
        end
      end
    end
  end
end
