redis = require 'redis'
moment = require 'moment'

class Buoy

  @all: (done) ->
    client = redis.createClient()
    # Get all buoys we're tracking
    client.zrange 'buoys', 0, -1, (err, slugs) ->
      console.log slugs
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
        # Doing on the server...
        buoy.latest.updated_ago = moment.unix(parseInt(buoy.latest.created_at, 10)).fromNow()
        # All done...
        done err, buoy


module.exports = Buoy
