require 'spec_helper'

describe RouteCounter::Util do
  describe ".normalize_path" do
    it "should trim stuff" do
      RouteCounter::Util.normalize_path("/hello/there/").should == "/hello/there"
      RouteCounter::Util.normalize_path("hello/there.json").should == "/hello/there.json"
      RouteCounter::Util.normalize_path("hello.html").should == "/hello.html"
      RouteCounter::Util.normalize_path("/").should == "/"
      RouteCounter::Util.normalize_path("").should  == "/"
    end
  end
end
