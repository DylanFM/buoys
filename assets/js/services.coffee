services = angular.module 'buoysApp.services', []

services.factory 'gauges', [
  '$rootScope', '$window'
  ($rootScope, $window) ->
    if $window._gauges?
      $rootScope.$on '$viewContentLoaded', -> $window._gauges.push(['track'])
]
