class Mapbadger.Models.Territory extends Backbone.Model
  paramRoot: 'territory'

  initialize: ->
    regions = new Mapbadger.Collections.RegionsCollection()
    regions.reset(@get('regions'))
    @setRegions(regions)
    @setRep(new Mapbadger.Models.Representative(@get('representative'))) if @has('representative')

  defaults:
    name: null

  setRegions: (regions) ->
    @regions = regions

  setRep: (rep) ->
    @rep = rep

  territoryRegionsAttributes: ->
    @regions.map (r) ->
      {region_id: r.get("id")}

  railsSafeAttributes: ->
    attrs = _.clone @attributes
    delete attrs.id
    delete attrs.regions
    delete attrs.representative
    attrs

  toJSON: ->
    json = {territory : @railsSafeAttributes()}
    _.extend(json.territory, {territory_regions_attributes: @territoryRegionsAttributes()}) if @regions
    _.extend(json.territory, {representative_id: @rep.id}) if @rep
    json.territory

class Mapbadger.Collections.TerritoriesCollection extends Backbone.Collection
  model: Mapbadger.Models.Territory
  url: '/territories'
