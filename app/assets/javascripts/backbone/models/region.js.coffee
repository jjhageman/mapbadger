class Mapbadger.Models.Region extends Backbone.Model
  paramRoot: 'region'

  defaults:
    name: null
    fipscode: null
    coords: null
  
class Mapbadger.Collections.RegionsCollection extends Backbone.Collection
  model: Mapbadger.Models.Region
  url: '/regions'