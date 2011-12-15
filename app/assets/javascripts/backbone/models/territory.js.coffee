class Mapbadger.Models.Territory extends Backbone.Model
  paramRoot: 'territory'
  url: '/territories'

  initialize: ->
    regions = new Mapbadger.Collections.RegionsCollection()
    regions.reset(@get('regions'))
    @setRegions(regions)

  defaults:
    name: null

  setRegions: (regions) ->
    @regions = regions

  territory_regions_attributes: ->
    @regions.map (r) ->
      {region_id: r.get("id")};

  toJSON: ->
    json = {territory : _.clone(@attributes)}
    _.extend(json.territory, {territory_regions_attributes: @territory_regions_attributes()})

class Mapbadger.Collections.TerritoriesCollection extends Backbone.Collection
  model: Mapbadger.Models.Territory
  url: '/territories'
