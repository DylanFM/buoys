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
        # Watch for history changes
        scope.$watch 'history', (history) ->
          graphs = $(el[0]).find '.graph'
          if graphs.length
            graphs.forEach (cont) ->
              # Empty
              d3.select(cont).selectAll('path').remove()
              # Process
              history = $(cont).data 'history'
              if history.length
                data   = $.map JSON.parse(history), (n,i) -> parseFloat(n, 10)
                min    = $(cont).data('min') or d3.min data
                max    = $(cont).data('max') or d3.max data
                width  = parseInt $(cont).css('width'), 10
                height = parseInt $(cont).css('height'), 10
                xScale = d3.scale.linear().domain([0, data.length-1]).rangeRound [2, width-2]
                yScale = d3.scale.linear().domain([min, max]).nice().rangeRound [2, height-2]
                line   = d3.svg.line()
                line.x (d, i) -> xScale(i)
                line.y (d) -> yScale(d)
                graph  = d3.select(cont).append('svg:svg').attr('width', '100%').attr('height', '100%')
                graph.append('svg:path').attr('d', line(data))
    }
]
