Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.IndexView extends Backbone.View
  template: JST["backbone/templates/territories/index"]
  tagName: "ul"
  id: "territories"

  initialize: () ->
    _.bindAll(this, 'addOne', 'addAll', 'render')
    
    @options.territories.bind('reset', @addAll)
    @options.territories.bind('add', @addAll)
    @map = @options.map
    @territoryForm = new Mapbadger.Views.Territories.NewView(collection: @options.territories, regions: @options.regions, map: @map)
   
  addAll: () ->
    @options.territories.each(@addOne)
  
  addOne: (territory) ->
    view = new Mapbadger.Views.Territories.TerritoryView({model : territory, map: @map})
    terr_view = view.render().el
    # $(terr_view).find(".territory").bind "click", (territory) =>
    #   view = new Mapbadger.Views.Territories.EditView(model: territory)
    #   $(".sidebar").html(view.render().el)
    @$("#saved").append(terr_view)
    # @$(".territory").bind("click", @renderEditTerritory, territory)
    # @map.displayTerritory(territory)

  renderEditTerritory: (territory) ->
    view = new Mapbadger.Views.Territories.EditView(model: territory)
    $(".sidebar").html(view.render().el)

  renderSidebar: ->
    $(@el).html(@template)
    @addAll()
    $(".sidebar").append(@territoryForm.render().el)

  render: ->
    @renderSidebar() 
    return this
