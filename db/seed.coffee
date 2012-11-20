redis = require 'redis'

client = redis.createClient()


# Buoy data
buoys = [
  {
    slug: 'sydney'
    name: 'Sydney'
    url: 'http://mhl.nsw.gov.au/data/syddir.gif'
  }
  {
    slug: 'byron-bay'
    name: 'Byron Bay'
    url: 'http://mhl.nsw.gov.au/data/byron.gif'
  }
  {
    slug: 'coffs-harbour'
    name: 'Coffs Harbour'
    url: 'http://mhl.nsw.gov.au/data/coffs.gif'
  }
  {
    slug: 'port-kembla'
    name: 'Port Kembla'
    url: 'http://mhl.nsw.gov.au/data/portko.gif'
  }
  {
    slug: 'batemans-bay'
    name: 'Batemans Bay'
    url: 'http://mhl.nsw.gov.au/data/batman.gif'
  }
  {
    slug: 'eden'
    name: 'Eden'
    url: 'http://mhl.nsw.gov.au/data/edeno.gif'
  }
  # {
  #   slug: 'crowdy-head'
  #   name: 'Crowdy Head'
  #   url: 'http://mhl.nsw.gov.au/data/crowdy.gif'
  # }
]


# Seed redis with the buoys we are tracking
for buoy in buoys
  # Set of buoy slugs
  client.sadd 'buoys', buoy.slug
  # Hash for each buoy
  client.hmset "buoys:#{buoy.slug}", buoy


# Output current state of the datastore
multi = client.multi()

multi.smembers 'buoys', (err, members) ->
  console.log '"buoys" set to', members

multi.keys 'buoys:*', (err, res) ->
  console.log "keys under buoys:*", res

for b in buoys
  multi.hgetall "buoys:#{b.slug}", (err, buoy) ->
    console.log "buoys:#{buoy.slug}", buoy

multi.exec()


# Done
client.quit (err, res) -> process.exit()
