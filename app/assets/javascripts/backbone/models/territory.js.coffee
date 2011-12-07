class Mapbadger.Models.Territory extends Backbone.Model
  paramRoot: 'territory'
  url: '/territories'

  # relations: [
  #   type: 'HasMany'
  #   # key: 'regions'
  #   # relatedModel: 'Mapbadger.Models.TerritoryRegion'
  #   # reverseRelation:
  #   #   key: 'territory'
  #   key: 'regions'
  #   relatedModel: 'Mapbadger.Models.Region'
  #   collectionType: 'Mapbadger.Collections.RegionsCollection'
  # ]

  initialize: ->
    @regions = new Mapbadger.Collections.RegionsCollection()

  # sync: (method, model, options) ->
  #   data = JSON.stringify model.toJSON()
  #   if (method == "create" || method == "update")
  #       json = model.attributes
  #       json = _.extend json, {regions_attributes: model.regions.toJSON()}
  #       data = JSON.stringify json

  #   options.data = data
  #   options.contentType = 'application/json'
  #   Backbone.sync method, model, options

  defaults:
    name: null

  toJSON: ->
    json = {territory : _.clone(@attributes)}
    _.extend(json.territory, {regions_attributes: @regions.toJSON()})
    # json.territory.regions_attributes = this.regions.toJSON()
    # json
  
class Mapbadger.Collections.TerritoriesCollection extends Backbone.Collection
  model: Mapbadger.Models.Territory
  url: '/territories'
