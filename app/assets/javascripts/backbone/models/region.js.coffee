class Mapbadger.Models.Region extends Backbone.Model
  paramRoot: 'region'

  initialize: ->
    zipcodes = new Mapbadger.Collections.ZipcodesCollection()
    zipcodes.reset(@get('zipcodes'))
    @setZipcodes(zipcodes)

  setZipcodes: (zipcodes) ->
    @zipcodes = zipcodes


class Mapbadger.Collections.RegionsCollection extends Backbone.Collection
  model: Mapbadger.Models.Region
  url: '/regions'
