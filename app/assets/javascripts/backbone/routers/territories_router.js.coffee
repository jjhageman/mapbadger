class Mapbadger.Routers.TerritoriesRouter extends Backbone.Router
  initialize: (options) ->
    @territories = new Mapbadger.Collections.TerritoriesCollection()
    @territories.reset options.territories

    @regions = new Mapbadger.Collections.RegionsCollection()
    @regions.reset options.regions

    @opportunities = new Mapbadger.Collections.OpportunitiesCollection()
    @opportunities.reset options.opportunities

    @reps = new Mapbadger.Collections.RepresentativesCollection()
    @reps.reset options.reps

    @map = new Mapbadger.Views.MapView({regions : @regions, opportunities: @opportunities})

  routes:
    "/new"      : "newTerritory"
    "/index"    : "index"
    "/:id/edit" : "edit"
    "/:id"      : "show"
    ".*"        : "index"

  newTerritory: ->
    @view = new Mapbadger.Views.Territories.NewView(collection: @territories)
    $("#territories").html(@view.render().el)

  index: ->
    $("#content").html(@map.render().el)
    @map.renderMap()
    @view = new Mapbadger.Views.Territories.IndexView(territories: @territories, regions: @regions, map: @map, reps: @reps)
    $("#sidebar").prepend(@view.render().el)
    @territoryForm = new Mapbadger.Views.Territories.NewView(collection: @territories, regions: @regions, map: @map)
    $("#sidebar").append(@territoryForm.render().el)

  show: (id) ->
    territory = @territories.get(id)
    
    @view = new Mapbadger.Views.Territories.ShowView(model: territory)
    $("#territories").html(@view.render().el)
    
  edit: (id) ->
    territory = @territories.get(id)

    @view = new Mapbadger.Views.Territories.EditView(model: territory)
    $("#sidebar").html(@view.render().el)
  
