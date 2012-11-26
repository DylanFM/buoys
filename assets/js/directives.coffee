directives = angular.module 'buoysApp.directives', []

directives.directive 'historyGraph', [
  'Buoy', (Buoy) ->
    {
      templateUrl: '/partials/buoyHistory'
      link: (scope, el, attrs) ->
        amount = attrs.amount
        # Wait for slug to be changed/set
        scope.$watch 'buoy.slug', (slug) ->
          if slug
            Buoy.history slug: slug, amount: amount, (history) -> scope.history = history
    }
]
