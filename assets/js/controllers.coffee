controllerModule = angular.module 'buoysApp.controllers', ['buoysApp.services']


# Display buoys index
controllerModule.controller 'BuoysCtrl', [
  '$scope', '$http'
  ($scope, $http) ->
    $http(method: 'GET', url: '/api/buoys.json')
      .success (data, status, headers, config) ->
        $scope.buoys = data
      .error (data, status, headers, config) ->
        console.log 'Error', data
]


# Display a buoy's page
controllerModule.controller 'BuoyCtrl', [
  '$scope', '$http', '$routeParams'
  ($scope, $http, $routeParams) ->
    $http(method: 'GET', url: "/api/buoys/#{$routeParams.slug}.json")
      .success (data, status, headers, config) ->
        $scope.buoy = data
      .error (data, status, headers, config) ->
        console.log 'Error', data
]
