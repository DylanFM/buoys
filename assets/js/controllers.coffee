controllerModule = angular.module 'buoysApp.controllers', ['buoysApp.services', 'buoysApp.resources']


# Display buoys index
controllerModule.controller 'BuoysCtrl', [
  '$scope', 'Buoy', 'gauges'
  ($scope, Buoy) ->
    Buoy.query (buoys) -> $scope.buoys = buoys
]


# Display a buoy's page
controllerModule.controller 'BuoyCtrl', [
  '$scope', '$routeParams', 'Buoy', 'gauges'
  ($scope, $routeParams, Buoy) ->
    Buoy.get slug: $routeParams.slug, (buoy) -> $scope.buoy = buoy
]
