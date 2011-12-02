class Mapbadger.Models.Territory extends Backbone.Model
  paramRoot: 'territory'

  defaults:
    name: null
  
class Mapbadger.Collections.TerritoriesCollection extends Backbone.Collection
  model: Mapbadger.Models.Territory
  url: '/territories'