angular.module('buoysApp', ['gauges'])
  .config [
    '$routeProvider', '$locationProvider'
    ($routeProvider, $locationProvider) ->

      $routeProvider
        .when('/', controller: BuoysCtrl, templateUrl: 'partials/buoys')
        .when('/:slug', controller: BuoyCtrl, templateUrl: 'partials/buoy')
        .otherwise(redirectTo: '/')

      $locationProvider.html5Mode true
  ]


# Onload
$ ->
  new FastClick document.body
