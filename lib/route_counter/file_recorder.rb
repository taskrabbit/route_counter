require 'fileutils'
require 'monitor'

module RouteCounter
  class FileRecorder
    ROOT_IDENTIFIER = "_______root"

    class << self
      def safe_path(path)
        path.slice!(0) if path[0] == '/' # remove leading
        path = ROOT_IDENTIFIER if path == '' # handle root

        path
      end

      def unsafe_path(path)
        path = "" if path == ROOT_IDENTIFIER
        path = "/#{path}" unless path[0] == '/'
        path
      end

      def parent_directory
        RouteCounter.config.directory
      end

      def current_directory
        File.join(parent_directory, 'current')
      end

      def path_visited(path)
        file_path = File.join(File.join(current_directory, safe_path(path)))
        dir_path  = File.dirname(file_path)
        FileUtils.mkdir_p(dir_path)

        logdev = LogDevice.new(file_path)
        logdev.write('G')
        logdev.close
      end
    end

    class LogDevice # from Logger

      attr_reader :dev
      attr_reader :filename

      class LogDeviceMutex
        include MonitorMixin
      end

      def initialize(log = nil, opt = {})
        @dev = @filename = nil
        @mutex = LogDeviceMutex.new
        if log.respond_to?(:write) and log.respond_to?(:close)
          @dev = log
        else
          @dev = open_logfile(log)
          @dev.sync = true
          @filename = log
        end
      end

      def write(message)
        @mutex.synchronize do
          @dev.write(message)
        end
      end

      def close
        begin
          @mutex.synchronize do
            @dev.close rescue nil
          end
        rescue Exception
          @dev.close rescue nil
        end
      end

    private

      def open_logfile(filename)
        begin
          open(filename, (File::WRONLY | File::APPEND))
        rescue Errno::ENOENT
          create_logfile(filename)
        end
      end

      def create_logfile(filename)
        begin
          logdev = open(filename, (File::WRONLY | File::APPEND | File::CREAT | File::EXCL))
          logdev.flock(File::LOCK_EX)
          logdev.sync = true
          logdev.flock(File::LOCK_UN)
        rescue Errno::EEXIST
          # file is created by another process
          logdev = open_logfile(filename)
          logdev.sync = true
        end
        logdev
      end
    end
  end
end
