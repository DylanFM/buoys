buoysApp = angular.module 'buoysApp.app', ['buoysApp.controllers', 'buoysApp.filters']

buoysApp.config [
    '$routeProvider', '$locationProvider'
    ($routeProvider, $locationProvider) ->

      $routeProvider
        .when('/',      controller: 'BuoysCtrl',  templateUrl: 'partials/buoys')
        .when('/about', controller: 'AboutCtrl',  templateUrl: 'partials/about')
        .when('/:slug', controller: 'BuoyCtrl',   templateUrl: 'partials/buoy')
        .otherwise(redirectTo: '/')

      $locationProvider.html5Mode true
  ]


# Onload
$ ->
  new FastClick document.body
