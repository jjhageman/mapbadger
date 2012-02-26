class Mapbadger.Models.Geometry extends Backbone.Model
  paramRoot: 'geometry'

  paths: ->
    google.maps.geometry.encoding.decodePath @get('polyline')

class Mapbadger.Collections.GeometriesCollection extends Backbone.Collection
  model: Mapbadger.Models.Geometry
  url: '/geometries'
