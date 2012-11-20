redis = require 'redis'

client = redis.createClient()

exports.buoys = (req, res) ->
  # TODO move to model
  # Get all buoys we're tracking
  client.smembers 'buoys', (err, slugs) ->
    # Get each buoy's info
    multi = client.multi()
    multi.hgetall "buoys:#{slug}" for slug in slugs
    multi.exec (err, response) ->
      # Return collection of buoys as JSON
      res.json(response)

exports.buoy = (req, res) ->
  client.hgetall "buoys:#{req.params.slug}", (err, response) ->
    res.json(response)
