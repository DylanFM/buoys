config    = require './config/'

if config.get('NODE_ENV') is 'production'
  require('nodefly').profile config.get('NODEFLY_APPLICATION_KEY'), [config.get('APPLICATION_NAME'),'Heroku']

Buoy          = require './models/buoy'
redis         = require 'redis'
moment        = require 'moment'
parseMHLGraph = require 'mhl-buoy-data'
_             = require 'underscore'

if config.get('NODE_ENV') is 'production'
  bugsnag = require 'bugsnag'
  bugsnag.register(config.get('BUGSNAG_API_KEY')) 

# Let's keep this snappy
setTimeout ->
  process.exit(1)
, 20000

# Get all buoys
Buoy.all (err, buoys) ->

  throw err if err
  bugsnag.notify new Error(error) if bugsnag

  # Loop through each buoy
  for buoy in buoys

    # Make note of the time
    now = moment()
    now.utc() # It should be in UTC for DB storage

    do (buoy, now) ->
      console.log "#{buoy.name} - fetching graph from #{buoy.url}"

      # Parse the buoy's graph
      parseMHLGraph buoy.url, (err, conditions) ->
        try

          throw new Error(err) if err

          console.log "#{buoy.name} - graph parsed, storing in redis", conditions

          conditions.created_at = now.valueOf()

          # Issue with node redis in storing this object as a hash
          # Going to cast values of object
          conditions[item[0]] = '' + item[1] for item in _.pairs(conditions)

          client = redis.createClient(config.get('REDIS_PORT'), config.get('REDIS_HOSTNAME'))
          client.auth(config.get('REDIS_AUTH')) if config.get('REDIS_AUTH')

          client.on 'ready', ->

            key = "buoys:#{buoy.slug}:#{now.year()}:#{now.month()}:#{now.date()}:#{now.hours()}:#{now.minutes()}"

            # Store the graph's data and timestamp in
            #  - buoys:slug:latest
            client.hmset "buoys:#{buoy.slug}:latest", conditions
            #  - buoys:slug:yyyy:mm:dd:hh::mm
            client.hmset key, conditions

            # Store key in buoys:slug:recent list
            recentKey = "buoys:#{buoy.slug}:recent"
            client.lpush recentKey, key
            # Ensure recent list only has up to 50 items
            client.ltrim recentKey, 0, 50

            client.quit()

        catch error
          console.log "#{buoy.name} - error", error
          bugsnag.notify new Error(error) if bugsnag
          process.exit()
