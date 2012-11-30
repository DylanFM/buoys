resources = angular.module 'buoysApp.resources', []

resources.factory 'Buoy', [
  '$http'
  ($http) ->
    class Buoy

      #
      # Class methods
      # Mimic ngResource for now
      #

      @query: (force=false) ->
        $http.get('/api/buoys', cache: !force)
          .then (resp) ->
            resp.data.map (b) -> new Buoy(b)
      
      @get: (slug, force=false) ->
        $http.get("/api/buoys/#{slug}", cache: !force)
          .then (resp) -> new Buoy(resp.data)

      @history: (slug, amount, force=false) ->
        $http.get("/api/buoys/#{slug}/history", { amount, cache: !force })
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
