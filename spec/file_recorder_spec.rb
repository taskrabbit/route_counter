require 'spec_helper'
require 'fileutils'

describe RouteCounter::FileRecorder do
  before(:each) do
    FileUtils.rm_rf(RouteCounter::FileRecorder.parent_directory)
  end

  describe "#action_visited" do
    it "should write to file" do
      controller = "comments"
      action_name = "create"

      current_path = File.join(RouteCounter::FileRecorder.parent_directory, "current")
      check_path = File.join(current_path, "comments", "create")

      File.exists?(check_path).should == false

      RouteCounter::FileRecorder.action_visited(controller, action_name)

      File.exists?(check_path).should == true
      File.read(check_path).should == 'X'

      RouteCounter::FileRecorder.action_visited(controller, action_name)

      File.read(check_path).should == 'XX'

      paths = RouteCounter::FileRecorder.paths_visited
      paths.should == { "comments#create" => 2 }

      RouteCounter::FileRecorder.action_visited("engine/comments", "create")
      paths = RouteCounter::FileRecorder.paths_visited
      paths.should == { "comments#create" => 2, "engine/comments#create" => 1 }

      File.exist?(current_path).should == true

      paths = RouteCounter::FileRecorder.rotate!
      paths.should == { "comments#create" => 2, "engine/comments#create" => 1 }

      File.exist?(current_path).should == false
    end
  end
end