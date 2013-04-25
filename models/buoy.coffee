config  = require '../config/'
redis   = require 'redis'
moment  = require 'moment'
_       = require 'underscore'

class Buoy

  @all: (done) ->

    client = redis.createClient(config.get('REDIS_PORT'), config.get('REDIS_HOSTNAME'))
    client.auth(config.get('REDIS_AUTH')) if config.get('REDIS_AUTH')

    client.on 'ready', ->

      # Get all buoys we're tracking
      client.zrange 'buoys', 0, -1, (err, slugs) ->

        unless slugs?.length
          done new Error("There aren't any buoy slugs to query in redis.")
        
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
              # Now return
              done err, buoys


  @findBySlug: (slug, done) ->

    client = redis.createClient(config.get('REDIS_PORT'), config.get('REDIS_HOSTNAME'))
    client.auth(config.get('REDIS_AUTH')) if config.get('REDIS_AUTH')

    client.on 'ready', ->

      client.multi()
        .hgetall("buoys:#{slug}")
        .hgetall("buoys:#{slug}:latest")
        .exec (err, response) ->
          client.quit()
          buoy = response[0] # 1st member should be the buoy data
          if buoy
            buoy.latest = response[1] # 2nd member is the latest reading
            # All done...
            done err, buoy
          else
            done new Error('Buoy not found')


  # Fetch n number of items from a buoy's recent history
  @history: (slug, amount=20, done) ->

    # To work with lrange, we have 0 based indexes
    amount--

    unless amount < 50
      done new Error('Cannot request more than 50 items from history')

    client = redis.createClient(config.get('REDIS_PORT'), config.get('REDIS_HOSTNAME'))
    client.auth(config.get('REDIS_AUTH')) if config.get('REDIS_AUTH')

    client.on 'ready', ->

      client.lrange "buoys:#{slug}:recent", 0, amount, (err, keys) ->
        # We have keys for the ones we're after
        multi = client.multi()
        multi.hgetall key for key in keys
        # Execute query to fetch all history keys
        multi.exec (err, history) ->
          # Done with redis
          client.quit()

          if err
            done err
            return

          # History is an array of conditions, time ordered
          history.reverse() # It needs to be reveresed to be ordered by date ascending

          # Along with this we should return arrays for the past hsig, tsig and dir.
          # Thinking of this is that we can cache here and do it once per hour,
          # saving pushing it to the client and having them do it each request.
          
          directions = _.map history, (c) -> c.direction
          hsig       = _.map history, (c) -> c.hsig
          tsig       = _.map history, (c) -> c.tsig

          # Return
          done null, { directions, hsig, tsig, history }


module.exports = Buoy
