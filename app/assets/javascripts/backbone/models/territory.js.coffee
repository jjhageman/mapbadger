class Mapbadger.Models.Territory extends Backbone.Model
  paramRoot: 'territory'
  url: '/territories'

  initialize: ->
    @regions = new Mapbadger.Collections.RegionsCollection()

  defaults:
    name: null

  toJSON: ->
    json = {territory : _.clone(@attributes)}
    _.extend(json.territory, {territory_regions_attributes: @regions.toJSON()})

class Mapbadger.Collections.TerritoriesCollection extends Backbone.Collection
  model: Mapbadger.Models.Territory
  url: '/territories'
