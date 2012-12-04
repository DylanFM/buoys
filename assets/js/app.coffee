app = angular.module 'buoysApp.app', ['buoysApp.controllers', 'buoysApp.filters']

app.config [
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
