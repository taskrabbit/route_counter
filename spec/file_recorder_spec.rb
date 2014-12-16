require 'spec_helper'
require 'fileutils'

describe RouteCounter::FileRecorder do
  before(:each) do
    FileUtils.rm_rf(RouteCounter::FileRecorder.parent_directory)
  end

  describe "#safe_path" do
    it "should trim stuff" do
      RouteCounter::FileRecorder.safe_path("/hello/there").should == "hello/there"
      RouteCounter::FileRecorder.safe_path("/hello/there.json").should == "hello/there.json"
      RouteCounter::FileRecorder.safe_path("hello/there.json").should == "hello/there.json"
      RouteCounter::FileRecorder.safe_path("hello.html").should == "hello.html"
      RouteCounter::FileRecorder.safe_path("/").should == "_______root"
      RouteCounter::FileRecorder.safe_path("").should  == "_______root"
    end
  end

  describe "#unsafe_path" do
    it "should add stuff" do
      RouteCounter::FileRecorder.unsafe_path("/hello/there").should == "/hello/there"
      RouteCounter::FileRecorder.unsafe_path("hello/there").should == "/hello/there"
      RouteCounter::FileRecorder.unsafe_path("hello/there.json").should == "/hello/there.json"
      RouteCounter::FileRecorder.unsafe_path("hello.html").should == "/hello.html"
      RouteCounter::FileRecorder.unsafe_path("_______root").should == "/"
      RouteCounter::FileRecorder.unsafe_path("").should == "/"
    end
  end

  describe "#path_visited" do
    it "should write to file" do
      url = "/test/me"
      check_path = File.join(RouteCounter::FileRecorder.parent_directory, "current", "test", "me")

      File.exists?(check_path).should == false

      RouteCounter::FileRecorder.path_visited(url)

      File.exists?(check_path).should == true
      File.read(check_path).should == 'G'

      RouteCounter::FileRecorder.path_visited(url)

      File.read(check_path).should == 'GG'
    end
  end
end