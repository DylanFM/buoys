angular.module('gauges', ['ng']).service 'gauges', [
  '$rootScope', '$window'
  ($rootScope, $window) ->
    if $window._gauges?
      $rootScope.$on '$viewContentLoaded', -> $window._gauges.push(['track'])
]
