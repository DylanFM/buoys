redis = require 'redis'

class Buoy

  @all: (done) ->
    client = redis.createClient()
    # Get all buoys we're tracking
    client.smembers 'buoys', (err, slugs) ->
      # Get each buoy's info
      multi = client.multi()
      multi.hgetall "buoys:#{slug}" for slug in slugs
      multi.exec (err, response) ->
        client.quit()
        done err, response

  @findBySlug: (slug, done) ->
    client = redis.createClient()
    client.multi()
      .hgetall("buoys:#{slug}")
      .hgetall("buoys:#{slug}:latest")
      .exec (err, response) ->
        client.quit()
        buoy = response[0] # 1st member should be the buoy data
        buoy.latest = response[1] # 2nd member is the latest reading
        done err, buoy


module.exports = Buoy
