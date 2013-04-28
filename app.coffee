config    = require './config/'

if config.get('NODE_ENV') is 'production'
  require('nodefly').profile config.get('NODEFLY_APPLICATION_KEY'), [config.get('APPLICATION_NAME'),'Heroku']

express   = require 'express'
apiRoutes = require './routes/api'
bugsnag   = require 'bugsnag'

app = module.exports = express()

app.configure ->
  app.use app.router

  # Handle 404s
  # Using example error-pages from express repo
  app.use (req, res, next) ->
    res.status 404

    res.send error: 'Not found' if req.accepts 'json'

    res.type('txt').send 'Not found'

app.configure 'development', ->
  app.use express.errorHandler dumpExceptions: true, showStack: true

app.configure 'production', ->
  app.use bugsnag.register(config.get('BUGSNAG_API_KEY'))
  app.use express.errorHandler()

  # Handle 500s
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.send error: err if req.accepts 'json'

    res.type('txt').send err

# Routes
app.get '/api/buoys', apiRoutes.buoys
app.get '/api/buoys/:slug', apiRoutes.buoy
app.get '/api/buoys/:slug/history', apiRoutes.buoyHistory

# Start server
app.listen config.get('PORT'), ->
  console.log "Express server listening on port #{@address().port}"
