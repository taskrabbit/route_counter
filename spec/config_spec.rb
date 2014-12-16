require 'spec_helper'

describe RouteCounter::Config do
  it "should be returned from the module" do
    RouteCounter.config.class.name.should == "RouteCounter::Config"
  end

  describe ".directory" do
    it "should default to ~/" do
      RouteCounter.config.directory.to_s.should == Dir.home
    end

    it "should be able to be set" do
      RouteCounter.config.directory = "something"
      RouteCounter.config.directory.should == "something"
    end
  end

end