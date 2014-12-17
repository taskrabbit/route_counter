namespace :routes do
  namespace :count do
    desc "Shows the routes and if they've been used locally"
    task local: :environment do
      RouteCounter::ConsoleFormatter.puts!(RouteCounter::FileRecorder)
    end
  end
end
