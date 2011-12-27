class Mapbadger.Models.Territory extends Backbone.Model
  paramRoot: 'territory'

  initialize: ->
    regions = new Mapbadger.Collections.RegionsCollection()
    regions.reset(@get('regions'))
    @setRegions(regions)

  defaults:
    name: null

  setRegions: (regions) ->
    @regions = regions

  territoryRegionsAttributes: ->
    @regions.map (r) ->
      {region_id: r.get("id")}

  railsSafeAttributes: ->
    attrs = _.clone @attributes
    delete attrs.id
    delete attrs.regions
    attrs

  toJSON: ->
    json = {territory : @railsSafeAttributes()}
    _.extend(json.territory, {territory_regions_attributes: @territoryRegionsAttributes()})

class Mapbadger.Collections.TerritoriesCollection extends Backbone.Collection
  model: Mapbadger.Models.Territory
  url: '/territories'
