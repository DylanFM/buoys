Buoy = require '../models/buoy'

# Render collection of buoys as JSON
exports.buoys = (req, res) ->
  Buoy.all (err, buoys) -> res.json(buoys)

# Render requested buoy as JSON
exports.buoy = (req, res) ->
  Buoy.findBySlug req.params.slug, (err, buoy) -> res.json(buoy)
