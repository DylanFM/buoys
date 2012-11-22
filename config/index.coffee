fs    = require 'fs'
nconf = require 'nconf'
url   = require 'url'

nconf
  .argv()
  .env()
  .file(file: './config/config.json')

nconf.defaults
  'NODE_ENV': 'development'

if redisUrl = url.parse nconf.get('OPENREDIS_URL')
  nconf.set 'REDIS_PORT', redisUrl.port
  nconf.set 'REDIS_HOSTNAME', redisUrl.hostname
  nconf.set 'REDIS_AUTH', redisUrl.auth.split(':')[1] if redisUrl.auth


module.exports = nconf
