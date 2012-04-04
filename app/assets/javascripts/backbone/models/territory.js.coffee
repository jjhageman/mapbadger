class Mapbadger.Models.Territory extends Backbone.Model
  paramRoot: 'territory'

  initialize: ->
    regions = new Mapbadger.Collections.RegionsCollection()
    regions.reset(@get('regions'))
    @setRegions(regions)

    zipcodes = new Mapbadger.Collections.ZipcodesCollection()
    zipcodes.reset(@get('zipcodes'))
    @setZipcodes(zipcodes)

    opportunities = new Mapbadger.Collections.OpportunitiesCollection()
    opportunities.reset()
    @setOpportunities(opportunities)

    @setRep(new Mapbadger.Models.Representative(@get('representative'))) if @has('representative')

    @setBounds()

  defaults:
    name: null

  setBounds: ->
    bounding_data = @get('bounding_data')
    if bounding_data?
      sw = new google.maps.LatLng(bounding_data.sw_y, bounding_data.sw_x)
      ne = new google.maps.LatLng(bounding_data.ne_y, bounding_data.ne_x)
      @bounds = new google.maps.LatLngBounds(sw,ne)

  setRegions: (regions) ->
    @regions = regions

  setZipcodes: (zipcodes) ->
    @zipcodes = zipcodes

  setOpportunities: (opportunities) ->
    @opportunities = opportunities

  setRep: (rep) ->
    @rep = rep

  territoryRegionsAttributes: ->
    @regions.map (r) ->
      {region_id: r.get("id")}

  territoryZipcodesAttributes: ->
    @zipcodes.map (z) ->
      {zipcode_id: z.get("id")}

  railsSafeAttributes: ->
    attrs = _.clone @attributes
    delete attrs.id
    delete attrs.created_at
    delete attrs.updated_at
    delete attrs.bounding_data
    delete attrs.regions
    delete attrs.zipcodes
    delete attrs.representative
    attrs

  toJSON: ->
    json = {territory : @railsSafeAttributes()}
    _.extend(json.territory, {territory_regions_attributes: @territoryRegionsAttributes()}) unless @regions.isEmpty()
    _.extend(json.territory, {territory_zipcodes_attributes: @territoryZipcodesAttributes()}) unless @zipcodes.isEmpty()
    _.extend(json.territory, {representative_id: @rep.id}) if @rep
    json.territory

class Mapbadger.Collections.TerritoriesCollection extends Backbone.Collection
  model: Mapbadger.Models.Territory
  url: '/territories'
