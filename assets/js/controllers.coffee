window.BuoysCtrl = ($scope, $http) ->
  $http(method: 'GET', url: '/api/buoys.json')
    .success (data, status, headers, config) ->
      $scope.buoys = data.buoys
    .error (data, status, headers, config) ->
      console.log 'Error', data
