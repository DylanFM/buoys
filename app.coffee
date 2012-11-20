express = require 'express'
app = express()

app.get '/', (req, res) ->
  res.send 'Oh buoy!'

app.listen 3000
console.log 'Listening on port 3000'
