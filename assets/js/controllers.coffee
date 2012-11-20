window.BuoysCtrl = ($scope, $http) ->
  $http(method: 'GET', url: '/api/buoys.json')
    .success (data, status, headers, config) ->
      $scope.buoys = data
    .error (data, status, headers, config) ->
      console.log 'Error', data

window.BuoyCtrl = ($scope, $http, $routeParams) ->
  $http(method: 'GET', url: "/api/buoys/#{$routeParams.slug}.json")
    .success (data, status, headers, config) ->
      $scope.buoy = data
    .error (data, status, headers, config) ->
      console.log 'Error', data
