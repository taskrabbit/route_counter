require 'fileutils'
require 'monitor'

# A recorder implements these class methods
#   * action_visited(controller_name, action_name) : record that it was visited
#   * actions_visited : returns hash of url => count
#   * rotate! : backup what was recorded and start counting again. returns hash.
#   * clear!  : clear everything out

module RouteCounter
  class FileRecorder
    class << self

      def parent_directory
        RouteCounter.config.directory
      end

      def current_directory
        File.join(parent_directory, 'current')
      end

      def read_directory(root)
        out = {}
        Dir[ File.join(root, '**', '*') ].each do |file|
          next if File.directory?(file)
          hits = File.size(file) # each should be 1 byte
          action_name = File.basename(file)
          controller_name = File.dirname(file)
          controller_name.gsub!("#{root}/", '')
          key = "#{controller_name}##{action_name}"
          out[key] ||= 0
          out[key] += hits
        end
        out
      end

      def action_visited(controller_name, action_name)
        # write down it was visited
        file_path = File.join(File.join(current_directory, controller_name, action_name))
        logdev = LogDevice.new(file_path)
        logdev.write('X')
        logdev.close
      end

      def actions_visited
        # returns what was visited and counts
        read_directory(current_directory)
      end

      def rotate!
        # lock the current one and return the visited
        alt_directory = File.join(parent_directory, "#{Time.now.to_i}-#{rand(99999999)}")
        FileUtils.mkdir_p(current_directory) # make sure it's there
        FileUtils.mv(current_directory, alt_directory)
        read_directory(alt_directory)
      end

      def clear!
        FileUtils.rm_rf(parent_directory)
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
          FileUtils.mkdir_p(File.dirname(filename))

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
