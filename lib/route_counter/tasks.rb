namespace :routes do
  namespace :count do
    desc "Shows the routes and if they've been used locally"
    task local: :environment do
      RouteCounter::ConsoleFormatter.puts!(RouteCounter::FileRecorder)
    end

    desc "Shows the routes and if they've been used globally"
    task global: :environment do
      RouteCounter::ConsoleFormatter.puts!(RouteCounter::RedisRecorder)
    end
  end
end

namespace :route_counter do
  desc "send local information to global"
  task snapshot: :environment do
    RouteCounter::Snapshot.transfer!(RouteCounter::FileRecorder)
  end

  namespace :local do
    desc "clears out the local store"
    task clear: :environment do
      RouteCounter::FileRecorder.clear!
    end
  end

  namespace :global do
    desc "clears out the global store"
    task clear: :environment do
      RouteCounter::RedisRecorder.clear!
    end
  end
end
