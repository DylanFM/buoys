controllers = angular.module 'buoysApp.controllers', ['buoysApp.services', 'buoysApp.resources', 'buoysApp.directives']


# Display buoys index
controllers.controller 'BuoysCtrl', [
  '$rootScope', '$scope', 'Buoy', 'gauges'
  ($rootScope, $scope, Buoy) ->
    Buoy.query().then (buoys) -> $scope.buoys = buoys

    # Support refreshing
    $rootScope.$on 'refresh', (e) ->
      Buoy.query(true).then (buoys) -> $scope.buoys = buoys
]


# Display a buoy's page
controllers.controller 'BuoyCtrl', [
  '$rootScope', '$scope', '$routeParams', 'Buoy', 'gauges'
  ($rootScope, $scope, $routeParams, Buoy) ->
    Buoy.get($routeParams.slug).then (buoy) -> $scope.buoy = buoy

    # Support refreshing
    $rootScope.$on 'refresh', (e) ->
      Buoy.get($scope.buoy.slug, true).then (buoy) -> $scope.buoy = buoy
]
