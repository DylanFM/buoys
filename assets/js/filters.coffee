filters = angular.module 'buoysApp.filters', []

filters.filter 'relative_time', [
  '$window'
  ($window) ->
    (date) ->
      if date and $window?.moment
        if date.length is 10                         # Old, we were storing seconds since epoch not ms
          date = "#{date}000"                        # Add milliseconds for backwards compatability
        utc = $window.moment.utc(parseInt(date, 10)) # Parse the time, stored in UTC (only parses ms)
        # TODO later on we can remove this stuff, as the old formatted times 
        #      will be long gone or I can write a script to fix them up 
        local = utc.local() # We want this as local though
        local.fromNow()     # This filter gives us relative time
]
