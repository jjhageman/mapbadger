class Mapbadger.Models.Representative extends Backbone.Model
  paramRoot: 'representative'

class Mapbadger.Collections.RepresentativesCollection extends Backbone.Collection
  model: Mapbadger.Models.Representative
  url: '/representatives'
