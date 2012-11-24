config  = require '../config'
redis   = require 'redis'
moment  = require 'moment'
Compass = require './compass'
_       = require 'underscore'

class Buoy

  @all: (done) ->

    client = redis.createClient(config.get('REDIS_PORT'), config.get('REDIS_HOSTNAME'))
    client.auth(config.get('REDIS_AUTH')) if config.get('REDIS_AUTH')

    # Get all buoys we're tracking
    client.zrange 'buoys', 0, -1, (err, slugs) ->
      buoys = null

      # Get each buoy's info
      multi = client.multi()
      multi.hgetall "buoys:#{slug}" for slug in slugs
      multi.exec (err, response) ->
        if err
          done err
        else
          buoys = response

      # Used later on for combining data sets
      latestToBuoy = (resp, bc) -> 
        bc[0].latest = bc[1]
        resp.push bc[0]
        resp

      # Get their latest conditions
      multi = client.multi()
      multi.hgetall "buoys:#{slug}:latest" for slug in slugs
      multi.exec (err, response) ->
        client.quit()
        if err
          done err
        else
          # Combine the data sets
          buoys = _.reduce(_.zip(buoys, response), latestToBuoy, [])
          # Duplicate... this stuff needs love here!
          buoys = _.map buoys, (buoy) ->
            if buoy.latest and buoy.latest.direction
              buoy.latest.directionString = Compass.directionFromDegrees parseFloat(buoy.latest.direction, 10)
            buoy
          # Now return
          done err, buoys


  @findBySlug: (slug, done) ->

    client = redis.createClient(config.get('REDIS_PORT'), config.get('REDIS_HOSTNAME'))
    client.auth(config.get('REDIS_AUTH')) if config.get('REDIS_AUTH')

    client.multi()
      .hgetall("buoys:#{slug}")
      .hgetall("buoys:#{slug}:latest")
      .exec (err, response) ->
        client.quit()
        buoy = response[0] # 1st member should be the buoy data
        buoy.latest = response[1] # 2nd member is the latest reading
        # Doing on the server...
        buoy.latest.updated_ago = moment.unix(parseInt(buoy.latest.created_at, 10)).fromNow()
        buoy.latest.directionString = Compass.directionFromDegrees parseFloat(buoy.latest.direction, 10)
        # All done...
        done err, buoy


  # Fetch n number of items from a buoy's recent history
  @history: (slug, amount=20, done) ->

    unless amount <= 50
      done new Error('Cannot request more than 50 items from history')

    client = redis.createClient(config.get('REDIS_PORT'), config.get('REDIS_HOSTNAME'))
    client.auth(config.get('REDIS_AUTH')) if config.get('REDIS_AUTH')

    client.lrange "buoys:#{slug}:recent", 0, amount, (err, keys) ->
      # We have keys for the ones we're after
      multi = client.multi()
      multi.hgetall key for key in keys
      # Execute query to fetch all history keys
      multi.exec (err, history) ->
        client.quit()
        if err
          done err
        else
          done err, history


module.exports = Buoy
