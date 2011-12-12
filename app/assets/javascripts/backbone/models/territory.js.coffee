class Mapbadger.Models.Territory extends Backbone.Model
  paramRoot: 'territory'
  url: '/territories'

  initialize: ->
    # @regions = new Mapbadger.Collections.RegionsCollection()
    var regions = new Mapbadger.Collections.RegionsCollecton.reset(@get('regions`'))
    @setTasks(regions);

  defaults:
    name: null

  setRegions: function(regions) {
    @regions = regions;
  }

  toJSON: ->
    json = {territory : _.clone(@attributes)}
    _.extend(json.territory, {territory_regions_attributes: @regions.toJSON()})

class Mapbadger.Collections.TerritoriesCollection extends Backbone.Collection
  model: Mapbadger.Models.Territory
  url: '/territories'
