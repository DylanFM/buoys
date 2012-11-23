controllerModule = angular.module 'buoysApp.controllers', ['buoysApp.services', 'buoysApp.resources']


# Display buoys index
controllerModule.controller 'BuoysCtrl', [
  '$scope', 'Buoy', 'gauges'
  ($scope, Buoy) -> $scope.buoys = Buoy.query()
]


# Display a buoy's page
controllerModule.controller 'BuoyCtrl', [
  '$scope', '$routeParams', 'Buoy', 'gauges'
  ($scope, $routeParams, Buoy) ->
    $scope.buoy = Buoy.get slug: $routeParams.slug

    $scope.refresh = ($event) -> 
      $event.preventDefault()
      $event.stopPropagation()
      Buoy.get slug: $scope.buoy.slug, (buoy) -> $scope.buoy = buoy
]
