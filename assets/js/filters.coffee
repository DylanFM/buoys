filters = angular.module 'buoysApp.filters', []

filters.filter 'hours24', [
  '$window'
  ($window) ->
    # NOTE duplicated with relative_time filter
    # TODO move this to a service
    (time) ->
      if time and $window?.moment
        if time.length is 10                         # Old, we were storing seconds since epoch not ms
          time = "#{time}000"                        # Add milliseconds for backwards compatability
        utc = $window.moment.utc(parseInt(time, 10)) # Parse the time, stored in UTC (only parses ms)
        # TODO later on we can remove this stuff, as the old formatted times 
        #      will be long gone or I can write a script to fix them up 
        local = utc.local() # We want this as local though
        "#{local.hours()}h"
]

# TODO change name to camel case
filters.filter 'relative_time', [
  '$window'
  ($window) ->
    (time) ->
      if time and $window?.moment
        if time.length is 10                         # Old, we were storing seconds since epoch not ms
          time = "#{time}000"                        # Add milliseconds for backwards compatability
        utc = $window.moment.utc(parseInt(time, 10)) # Parse the time, stored in UTC (only parses ms)
        # TODO later on we can remove this stuff, as the old formatted times 
        #      will be long gone or I can write a script to fix them up 
        local = utc.local() # We want this as local though
        local.fromNow()     # This filter gives us relative time
]

filters.filter 'compass', ->

  class Compass

    # From http://climate.umn.edu/snow_fence/Components/winddirectionanddegreeswithouttable3.htm
    @directions: [
      ['N', 348.75, 11.25]
      ['NNE', 11.25, 33.75]
      ['NE', 33.75, 56.25]
      ['ENE', 56.25, 78.75]
      ['E', 78.75, 101.25]
      ['ESE', 101.25, 123.75]
      ['SE', 123.75, 146.25]
      ['SSE', 146.25, 168.75]
      ['S', 168.75, 191.25]
      ['SSW', 191.25, 213.75]
      ['SW', 213.75, 236.25]
      ['WSW', 236.25, 258.75]
      ['W', 258.75, 281.25]
      ['WNW', 281.25, 303.75]
      ['NW', 303.75, 326.25]
      ['NNW', 326.25, 348.75]
    ]

    @directionFromDegrees: (deg) ->
      # Everything but the first, as it's handled differently
      match = _.find @directions[1..-1], (dir) -> deg >= dir[1] && deg < dir[2]
      if match then match[0] else 'N'

  # Filter function
  (degrees) ->
    Compass.directionFromDegrees parseInt(degrees, 10) if degrees
