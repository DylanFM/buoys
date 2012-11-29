resources = angular.module 'buoysApp.resources', []

resources.factory 'Buoy', [
  '$http'
  ($http) ->
    class Buoy

      #
      # Class methods
      # Mimic ngResource for now
      #

      @query: ->
        $http.get('/api/buoys')
          .then (resp) ->
            resp.data.map (b) -> new Buoy(b)
      
      @get: (slug) ->
        $http.get("/api/buoys/#{slug}")
          .then (resp) -> new Buoy(resp.data)

      @history: (slug, amount) ->
        $http.get("/api/buoys/#{slug}/history", { amount })
          .then (resp) -> resp.data

      #
      # Instance methods
      #

      constructor: (attrs) ->
        @name     = attrs.name
        @slug     = attrs.slug
        @position = attrs.position
        @url      = attrs.url
        @latest   = attrs.latest
]
