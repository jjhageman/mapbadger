class Mapbadger.Models.Territory extends Backbone.RelationalModel
  paramRoot: 'territory'
  
  relations:
    type: Backbone.HasMany
    key: 'regions'
    relatedModel: 'Region'
    collectionType: 'RegionsCollection'

  defaults:
    name: null
  
class Mapbadger.Collections.TerritoriesCollection extends Backbone.Collection
  model: Mapbadger.Models.Territory
  url: '/territories'
