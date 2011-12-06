class Mapbadger.Models.Region extends Backbone.Model
  paramRoot: 'region'

  # relations: [
  #   type: 'HasMany'
  #   key: 'territories'
  #   relatedModel: 'Mapbadger.Models.TerritoryRegion'
  #   reverseRelation:
  #     key: 'region'
  # ]

class Mapbadger.Collections.RegionsCollection extends Backbone.Collection
  model: Mapbadger.Models.Region
  url: '/regions'
