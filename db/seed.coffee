config = require '../config'
redis  = require 'redis'

client = redis.createClient(config.get('REDIS_PORT'), config.get('REDIS_HOSTNAME'))
client.auth(config.get('REDIS_AUTH')) if config.get('NODE_ENV') is 'production'

# Buoy data
buoys = [
  {
    slug: 'byron-bay'
    name: 'Byron Bay'
    url: 'http://mhl.nsw.gov.au/data/byron.gif'
    pos: '1'
  }
  {
    slug: 'coffs-harbour'
    name: 'Coffs Harbour'
    url: 'http://mhl.nsw.gov.au/data/coffs.gif'
    pos: '2'
  }
  # {
  #   slug: 'crowdy-head'
  #   name: 'Crowdy Head'
  #   url: 'http://mhl.nsw.gov.au/data/crowdy.gif'
  #   pos: '3'
  # }
  {
    slug: 'sydney'
    name: 'Sydney'
    url: 'http://mhl.nsw.gov.au/data/syddir.gif'
    pos: '4'
  }
  {
    slug: 'port-kembla'
    name: 'Port Kembla'
    url: 'http://mhl.nsw.gov.au/data/portko.gif'
    pos: '5'
  }
  {
    slug: 'batemans-bay'
    name: 'Batemans Bay'
    url: 'http://mhl.nsw.gov.au/data/batman.gif'
    pos: '6'
  }
  {
    slug: 'eden'
    name: 'Eden'
    url: 'http://mhl.nsw.gov.au/data/edeno.gif'
    pos: '7'
  }
]


# Seed redis with the buoys we are tracking
for buoy in buoys
  pos = parseInt buoy.pos, 10
  # Sorted set of buoy slugs
  client.zadd 'buoys', pos, buoy.slug # Ordered from north to south
  # Hash for each buoy
  client.hmset "buoys:#{buoy.slug}", buoy


# Output current state of the datastore
multi = client.multi()

multi.zrange 'buoys', 0, -1, (err, members) ->
  console.log '"buoys" set to', members

multi.keys 'buoys:*', (err, res) ->
  console.log "keys under buoys:*", res

for b in buoys
  multi.hgetall "buoys:#{b.slug}", (err, buoy) ->
    console.log "buoys:#{buoy.slug}", buoy

multi.exec()


# Done
client.quit (err, res) -> process.exit()
