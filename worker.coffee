config    = require './config/'

if config.get('NODE_ENV') is 'production'
  require('nodefly').profile config.get('NODEFLY_APPLICATION_KEY'), [config.get('APPLICATION_NAME'),'Heroku']

Buoy          = require './models/buoy'
Q             = require 'q'
redis         = require 'redis'
moment        = require 'moment'
parseMHLGraph = require 'mhl-buoy-data'
_             = require 'underscore'

if config.get('NODE_ENV') is 'production'
  bugsnag = require 'bugsnag'
  bugsnag.register(config.get('BUGSNAG_API_KEY')) 

# Fetches buoys from redis
getBuoys = ->
  deferred = Q.defer()

  # Get all buoys
  Buoy.all (err, buoys) ->
    if err
      deferred.reject new Error(err)
    else
      deferred.resolve buoys

  deferred.promise

# Fetches the latest records for a buoy, returns a promise
fetchBuoyLatest = (buoy) ->

  console.log "#{buoy.name} - fetching graph from #{buoy.url}"

  now = moment().utc() # Make note of time (in UTC for DB storage)

  deferred = Q.defer()

  # Parse the buoy's graph
  parseMHLGraph buoy.url, (err, conditions) ->
    if err
      deferred.reject new Error(err)
    else
      deferred.resolve [buoy, conditions, now]

  deferred
    .promise
    .timeout 5000, "Timeout (5s) fetching #{buoy.name}'s graph" # We don't want this taking ages

# Updates a buoy with conditions
updateBuoy = (update) ->

  deferred = Q.defer()

  try

    [buoy, conditions, now] = update

    console.log "#{buoy.name} - graph parsed, storing in redis", conditions

    conditions.created_at = now.valueOf()

    # Issue with node redis in storing this object as a hash
    # Going to cast values of object
    conditions[item[0]] = '' + item[1] for item in _.pairs(conditions)

    key = "buoys:#{buoy.slug}:#{now.year()}:#{now.month()}:#{now.date()}:#{now.hours()}:#{now.minutes()}"

    # Hello redis client
    client = redis.createClient(config.get('REDIS_PORT'), config.get('REDIS_HOSTNAME'))
    client.auth(config.get('REDIS_AUTH')) if config.get('REDIS_AUTH')

    client.on 'ready', ->

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

      deferred.resolve()

  catch err
    deferred.reject err

  deferred.promise


# Get things going...
getBuoys()
  .then (buoys) ->
    Q.allResolved _.map(buoys, fetchBuoyLatest) # Get the latest buoy data
  .then (promises) ->
    updates = _.map promises, (promise) ->
      if promise.isFulfilled()
        updateBuoy promise.valueOf()
      else
        bugsnag.notify promise.valueOf().exception if bugsnag
        null # Just remember promises in this array
    Q.allResolved _.compact updates
  .fail (error) ->
    console.log error
    bugsnag.notify new Error(error) if bugsnag
  .finally ->
    process.exit()
