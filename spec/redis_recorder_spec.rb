require 'spec_helper'

describe RouteCounter::RedisRecorder do
  before(:each) do
    @redis = RouteCounter.config.redis
    RouteCounter::RedisRecorder.clear!
  end

  describe "#action_visited" do
    it "should write to file" do
      controller = "comments"
      action_name = "create"

      key = "route_counter:current"
      action_key = "#{controller}##{action_name}"
      @redis.exists(key).should == false

      RouteCounter::RedisRecorder.action_visited(controller, action_name)

      @redis.exists(key).should == true
      @redis.hget(key, action_key).to_i.should == 1

      RouteCounter::RedisRecorder.action_visited(controller, action_name)

      @redis.hget(key, action_key).to_i.should == 2

      paths = RouteCounter::RedisRecorder.paths_visited
      paths.should == { "comments#create" => 2 }

      RouteCounter::RedisRecorder.action_visited("engine/comments", "create")
      paths = RouteCounter::RedisRecorder.paths_visited
      paths.should == { "comments#create" => 2, "engine/comments#create" => 1 }

      @redis.exists(key).should == true

      RouteCounter::RedisRecorder.clear!

      @redis.exists(key).should == false
    end
  end
end