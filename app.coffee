express = require 'express'
routes = require './routes'
apiRoutes = require './routes/api'

app = module.exports = express()

app.configure ->
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'
  app.use require('connect-assets')()

# App routes

app.get '/', routes.index

app.get '/api/buoys.json', apiRoutes.buoys
app.get '/api/buoys/:slug.json', apiRoutes.buoy

app.get '*', routes.index

# Start server

app.listen 3000, ->
  console.log "Express server listening on port #{@address().port}"
