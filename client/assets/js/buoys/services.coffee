services = angular.module 'buoysApp.services', []

services.factory 'gauges', [
  '$rootScope', '$window'
  ($rootScope, $window) ->
    if $window._gauges?
      $rootScope.$on '$viewContentLoaded', -> $window._gauges.push(['track'])
]

services.factory 'loading', [
  '$rootScope', '$http', ($rootScope, $http) ->
    # If there are pending requests, count that as loading
    isLoading = -> $http.pendingRequests.length > 0
    # Watch this function (run it on each digest)
    $rootScope.$watch isLoading, (newValue, oldValue, scope) -> 
      # Set the loading property to the return of isLoading
      scope.loading = newValue
]
