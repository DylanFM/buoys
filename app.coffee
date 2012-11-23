config    = require './config/'
express   = require 'express'
routes    = require './routes'
apiRoutes = require './routes/api'
bugsnag   = require 'bugsnag'

app = module.exports = express()

app.configure ->
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'
  app.use require('connect-assets')()
  app.use app.router

app.configure 'development', ->
  app.use express.errorHandler dumpExceptions: true, showStack: true

app.configure 'production', ->
  app.use express.errorHandler()
  app.use bugsnag.register(config.get('BUGSNAG_API_KEY'))

# Routes
app.get '/', routes.index

app.get '/partials/:name', routes.partials # Angular templates

app.get '/api/buoys.json', apiRoutes.buoys
app.get '/api/buoys/:slug.json', apiRoutes.buoy

app.get '*', routes.index

# Start server

app.listen config.get('PORT'), ->
  console.log "Express server listening on port #{@address().port}"
