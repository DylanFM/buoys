express = require 'express'
app = express()

app.configure ->
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'

app.get '/', (req, res) ->
  res.render 'index'

app.listen 3000, ->
  console.log "Express server listening on port #{@address().port}"
