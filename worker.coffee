Buoy = require './models/buoy'
parseMHLGraph = require 'mhl-buoy-data'

# Get all buoys
Buoy.all (err, buoys) ->
  # Loop through each buoy
  for buoy in buoys
    console.log buoy.name
    # Make note of the time
    # Parse the buoy's graph
    # Store the graph's data and timestamp in
    #  - buoys:slug:latest
    #  - buoys:slug:yyyy:mm:dd:hh::mm
