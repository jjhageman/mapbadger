class Mapbadger.Models.Zipcode extends Backbone.Model
  paramRoot: 'zipcode'

  initialize: ->
    geometries = new Mapbadger.Collections.GeometriesCollection()
    geometries.reset @get('geometries')
    @setGeometries(geometries)

  setGeometries: (geometries) ->
    @geometries = geometries

class Mapbadger.Collections.ZipcodesCollection extends Backbone.Collection
  model: Mapbadger.Models.Zipcode
  url: '/zipcodes'
