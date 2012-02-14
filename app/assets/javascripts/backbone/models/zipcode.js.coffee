class Mapbadger.Models.Zipcode extends Backbone.Model
  paramRoot: 'zipcode'

class Mapbadger.Collections.ZipcodesCollection extends Backbone.Collection
  model: Mapbadger.Models.Zipcode
  url: '/zctas'
