resources = angular.module 'buoysApp.resources', ['ngResource']

resources.factory 'Buoy', [
  '$resource', ($resource) ->
    $resource '/api/buoys/:slug'
]
