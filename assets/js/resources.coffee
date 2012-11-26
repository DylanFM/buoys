resources = angular.module 'buoysApp.resources', ['ngResource']

resources.factory 'Buoy', [
  '$resource', ($resource) ->
    $resource '/api/buoys/:slug/:action', {},
      history: { method: 'GET', isArray: true, params: { action: 'history' } }
]
