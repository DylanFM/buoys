directives = angular.module 'buoysApp.directives', []


directives.directive 'refresh', [
  '$rootScope'
  ($rootScope) ->
    (scope, el) ->
      scope.refresh = ($event) ->
        $event.preventDefault()
        $event.stopPropagation()
        # Publish a refresh event
        $rootScope.$emit 'refresh'
]


directives.directive 'compass', ->
  (scope, el) ->
    # Called before buoy is loaded, watch for data
    scope.$watch 'buoy.latest.direction', (direction) ->
      if direction
        $(el[0]).animate rotate: "#{direction}deg"


directives.directive 'historyGraph', [
  '$rootScope', 'Buoy'
  ($rootScope, Buoy) ->
    {
      templateUrl: '/partials/buoyHistory'
      link: (scope, el, attrs) ->
        scope.amount = attrs.amount
        # Wait for slug to be changed/set
        scope.$watch 'buoy.slug', (slug) ->
          if slug
            Buoy.history(slug, scope.amount).then (history) -> scope.history = history
        # Support refreshing
        $rootScope.$on 'refresh', (e) ->
          Buoy.history(scope.buoy.slug, scope.amount, true).then (history) -> scope.history = history
        # Ensure numerical values
        cleanData = (raw) ->
          return unless raw?.length
          $.map JSON.parse(raw), (n,i) -> 
            if n then parseFloat(n, 10) else 0
        # Function for getting a line
        getLine = (data, width, height) ->
          min    = d3.min data
          max    = d3.max data
          xScale = d3.scale.linear().domain([0, data.length-1]).rangeRound [2, width-2]
          yScale = d3.scale.linear().domain([max, min]).nice().rangeRound [2, height-2]
          line   = d3.svg.line()
          line.x (d, i) -> xScale(i)
          line.y (d)    -> yScale(d)
          line
        # Watch for history changes
        scope.$watch 'history', (history) ->
          graphs = $(el[0]).find '.graph'
          if graphs.length
            graphs.forEach (cont) ->
              # Empty
              d3.select(cont).selectAll('svg').remove()
              # The values
              tsig = cleanData $(cont).data('tsig')
              hsig = cleanData $(cont).data('hsig')
              # Process
              if tsig?.length or hsig?.length
                width  = parseInt $(cont).css('width'), 10
                height = parseInt $(cont).css('height'), 10
                tLine = getLine tsig, width, height
                hLine = getLine hsig, width, height
                # Finish up graphing
                graph  = d3.select(cont).append('svg:svg').attr('width', '100%').attr('height', '100%')
                graph.append('svg:path').attr('d', tLine(tsig)).attr('class', 'period')
                graph.append('svg:path').attr('d', hLine(hsig)).attr('class', 'size')
    }
]
