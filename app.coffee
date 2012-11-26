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

  # Handle 404s
  # Using example error-pages from express repo
  app.use (req, res, next) ->
    res.status 404

    if req.accepts 'html'
      res.render '404', url: req.url
      return

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
    res.render '500', error: err

# Routes
app.get '/', routes.index
app.get '/:slug', routes.index

app.get '/partials/:name', routes.partials # Angular templates

app.get '/api/buoys', apiRoutes.buoys
app.get '/api/buoys/:slug', apiRoutes.buoy
app.get '/api/buoys/:slug/history', apiRoutes.buoyHistory

# Start server

app.listen config.get('PORT'), ->
  console.log "Express server listening on port #{@address().port}"
