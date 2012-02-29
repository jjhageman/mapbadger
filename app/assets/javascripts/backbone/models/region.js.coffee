class Mapbadger.Models.Region extends Backbone.Model
  paramRoot: 'region'

  initialize: ->
    zipcodes = new Mapbadger.Collections.ZipcodesCollection()
    zipcodes.reset(@get('zipcodes'))
    @setZipcodes(zipcodes)

    geometries = new Mapbadger.Collections.GeometriesCollection()
    geometries.reset @get('geometries')
    @setGeometries(geometries)

  setZipcodes: (zipcodes) ->
    @zipcodes = zipcodes

  setGeometries: (geometries) ->
    @geometries = geometries

class Mapbadger.Collections.RegionsCollection extends Backbone.Collection
  model: Mapbadger.Models.Region
  url: '/regions'
