services = angular.module 'buoysApp.services', []

services.factory 'gauges', [
  '$rootScope', '$window'
  ($rootScope, $window) ->
    console.log 'bang bang', $window._gauges
    if $window._gauges?
      $rootScope.$on '$viewContentLoaded', -> $window._gauges.push(['track'])
]

# angular.module('buoysApp', ['ng']).service 'gauges', [
#   '$rootScope', '$window'
#   ($rootScope, $window) ->
#     console.log 'bang bang', $window._gauges
#     if $window._gauges?
#       $rootScope.$on '$viewContentLoaded', -> $window._gauges.push(['track'])
# ]
