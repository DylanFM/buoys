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
        done(err, response)

  @findBySlug: (slug, done) ->
    client = redis.createClient()
    client.hgetall "buoys:#{slug}", (err, response) ->
      client.quit()
      done(err, response)


module.exports = Buoy
