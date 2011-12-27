class Mapbadger.Routers.TerritoriesRouter extends Backbone.Router
  initialize: (options) ->
    @territories = new Mapbadger.Collections.TerritoriesCollection()
    @territories.reset options.territories
    @regions = new Mapbadger.Collections.RegionsCollection()
    @regions.reset options.regions
    # @map = new Mapbadger.Views.MapView({regions : @regions})

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
    # $(".content").html(@map.render().el)
    # @map.renderMap()
    @view = new Mapbadger.Views.Territories.IndexView(territories: @territories, regions: @regions, map: @map)
    $(".sidebar").html(@view.render().el)

  show: (id) ->
    territory = @territories.get(id)
    
    @view = new Mapbadger.Views.Territories.ShowView(model: territory)
    $("#territories").html(@view.render().el)
    
  edit: (id) ->
    territory = @territories.get(id)

    @view = new Mapbadger.Views.Territories.EditView(model: territory)
    $(".sidebar").html(@view.render().el)
  
