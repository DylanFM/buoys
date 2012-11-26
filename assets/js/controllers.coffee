controllers = angular.module 'buoysApp.controllers', ['buoysApp.services', 'buoysApp.resources', 'buoysApp.directives']


# Display buoys index
controllers.controller 'BuoysCtrl', [
  '$scope', 'Buoy', 'gauges'
  ($scope, Buoy) -> $scope.buoys = Buoy.query()
]


# Display a buoy's page
controllers.controller 'BuoyCtrl', [
  '$scope', '$routeParams', 'Buoy', 'gauges'
  ($scope, $routeParams, Buoy) ->
    $scope.buoy = Buoy.get slug: $routeParams.slug

    $scope.refresh = ($event) -> 
      $event.preventDefault()
      $event.stopPropagation()
      Buoy.get slug: $scope.buoy.slug, (buoy) -> $scope.buoy = buoy
]
