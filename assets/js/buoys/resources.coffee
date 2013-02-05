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
        # To make use of caching throughout the app, call @query
        @query(force).then (buoys) ->
          # Select this buoy
          _.find buoys, (b) -> b.slug is slug

      @history: (slug, amount, force=false) ->
        $http.get("/api/buoys/#{slug}/history?amount=#{amount}", cache: !force)
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
