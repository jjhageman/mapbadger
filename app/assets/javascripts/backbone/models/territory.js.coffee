class Mapbadger.Models.Territory extends Backbone.RelationalModel
  paramRoot: 'territory'
  
  relations: [
    type: 'HasMany'
    key: 'regions'
    relatedModel: 'Mapbadger.Models.Region'
    collectionType: 'Mapbadger.Collections.RegionsCollection'
  ]

  defaults:
    name: null
  
class Mapbadger.Collections.TerritoriesCollection extends Backbone.Collection
  model: Mapbadger.Models.Territory
  url: '/territories'
