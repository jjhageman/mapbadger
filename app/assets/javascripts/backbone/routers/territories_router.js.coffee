class Mapbadger.Routers.TerritoriesRouter extends Backbone.Router
  initialize: (options) ->
    @territories = new Mapbadger.Collections.TerritoriesCollection()
    @territories.reset options.territories
    @regions = new Mapbadger.Collections.RegionsCollection()
    @regions.reset options.regions

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
    @view = new Mapbadger.Views.Territories.IndexView(territories: @territories, regions: @regions)
    @view.render()

  show: (id) ->
    territory = @territories.get(id)
    
    @view = new Mapbadger.Views.Territories.ShowView(model: territory)
    $("#territories").html(@view.render().el)
    
  edit: (id) ->
    territory = @territories.get(id)

    @view = new Mapbadger.Views.Territories.EditView(model: territory)
    $("#territories").html(@view.render().el)
  
