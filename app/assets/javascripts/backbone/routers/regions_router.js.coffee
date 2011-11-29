class Mapbadger.Routers.RegionsRouter extends Backbone.Router
  initialize: (options) ->
    @regions = new Mapbadger.Collections.RegionsCollection()
    @regions.reset options.regions

  routes:
    "/new"      : "newRegion"
    "/index"    : "index"
    "/:id/edit" : "edit"
    "/:id"      : "show"
    ".*"        : "index"

  newRegion: ->
    @view = new Mapbadger.Views.Regions.NewView(collection: @regions)
    $("#regions").html(@view.render().el)

  index: ->
    @view = new Mapbadger.Views.Regions.IndexView(regions: @regions)
    $(".content").html(@view.render().el)
    @view.map_view.render()
    @view.addAll()

  show: (id) ->
    region = @regions.get(id)
    
    @view = new Mapbadger.Views.Regions.ShowView(model: region)
    $("#regions").html(@view.render().el)
    
  edit: (id) ->
    region = @regions.get(id)

    @view = new Mapbadger.Views.Regions.EditView(model: region)
    $("#regions").html(@view.render().el)
  
