# RouteCounter

When you want to know how much your routes are being used.

This is particularly useful if you are wondering if they are used at all.

## Installation

Add this line to your application's Gemfile:

    gem 'route_counter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install route_counter

Enable the recording in an initializer and insert the middleware:

```ruby
  RouteCounter.config.enabled = true
  Rails.application.config.middleware.use RouteCounter::Middleware
```

Add to Rakefile:

```ruby
require "route_counter/tasks"
```

## Usage


Check what's been used.

```bash
  $ bundle exec rake routes:count:local
```

All of this gets stored on your disk. If you want to clear it out.

```bash
  $ bundle exec rake route_counter:local:clear
```

##  Global Usage

You might want to see the counts across your servers.
This will use Redis to aggregate info from across all of them.
First, you'll need to tell it where Redis is:

```ruby
RouteCounter.config.redis = Redis.new(connection_hash)
```

Then, you can clear out the remote store.
Or not to be cumulative to last time you took a snapshot

```bash
  $ bundle exec rake route_counter:global:clear
```

Then take a snapshot. You can do this in parallel on all of your servers (with Capistrano for example).

```bash
  $ bundle exec rake route_counter:snapshot
```

Then on one of the servers you can run to use the global numbers

```bash
  $ bundle exec rake routes:count:global
```

## TODO

* could make a middleware (or config option) that wrote directly to Redis
* should it record more info about the request?
* configurable error handler
