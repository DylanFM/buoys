controllers = angular.module 'buoysApp.controllers', ['buoysApp.services', 'buoysApp.resources', 'buoysApp.directives']


# Display buoys index
controllers.controller 'BuoysCtrl', [
  '$scope', 'Buoy', 'gauges'
  ($scope, Buoy) ->
    Buoy.query().then (buoys) -> $scope.buoys = buoys
]


# Display a buoy's page
controllers.controller 'BuoyCtrl', [
  '$scope', '$routeParams', 'Buoy', 'gauges'
  ($scope, $routeParams, Buoy) ->
    Buoy.get($routeParams.slug).then (buoy) -> $scope.buoy = buoy

    $scope.refresh = ($event) -> 
      $event.preventDefault()
      $event.stopPropagation()
      Buoy.get($scope.buoy.slug).then (buoy) -> $scope.buoy = buoy
]
