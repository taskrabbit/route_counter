module RouteCounter
  module Util
    def self.normalize_path(path)
      path = "/#{path}"
      path.squeeze!('/')
      path.sub!(%r{/+\Z}, '')
      path.gsub!(/(%[a-f0-9]{2})/) { $1.upcase }
      path = '/' if path == ''
      path
    end
  end
end
