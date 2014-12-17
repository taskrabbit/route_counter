namespace :routes do
  namespace :count do
    desc "Shows the routes and if they've been used locally"
    task local: :environment do
      RouteCounter::ConsoleFormatter.puts!(RouteCounter::FileRecorder)
    end
  end
end

namespace :route_counter do
  namespace :local do
    desc "clears out the local store"
    task clear: :environment do
      RouteCounter::FileRecorder.clear!
    end
  end
end
