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

  describe ".enabled" do
    it "should defualt to false" do
      RouteCounter.config.enabled.should == false
      RouteCounter.config.enabled?.should == false
    end

    it "should be able to be set" do
      RouteCounter.config.enabled = true

      RouteCounter.config.enabled.should == true
      RouteCounter.config.enabled?.should == true
    end
  end

end