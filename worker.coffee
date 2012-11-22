Buoy          = require './models/buoy'
redis         = require 'redis'
moment        = require 'moment'
parseMHLGraph = require 'mhl-buoy-data'
_             = require 'underscore'

# Get all buoys
Buoy.all (err, buoys) ->
  # Loop through each buoy
  for buoy in buoys

    # Make note of the time
    now = moment()

    do (buoy, now) ->
      console.log "#{buoy.name} - fetching graph from #{buoy.url}"

      try
        # Parse the buoy's graph
        parseMHLGraph buoy.url, (err, conditions) ->

          throw new Error(err) if err

          console.log "#{buoy.name} - graph parsed, storing in redis", conditions

          conditions.created_at = now.unix()

          # Issue with node redis in storing this object as a hash
          # Going to cast values of object
          conditions[item[0]] = '' + item[1] for item in _.pairs(conditions)

          client = redis.createClient()

          # Store the graph's data and timestamp in
          #  - buoys:slug:latest
          client.hmset "buoys:#{buoy.slug}:latest", conditions
          #  - buoys:slug:yyyy:mm:dd:hh::mm
          client.hmset "buoys:#{buoy.slug}:#{now.year()}:#{now.month()}:#{now.date()}:#{now.hours()}:#{now.minutes()}", conditions

          client.quit()
      catch error
        console.log "#{buoy.name} - error", error
