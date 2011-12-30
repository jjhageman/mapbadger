Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.IndexView extends Backbone.View
  template: JST["backbone/templates/territories/index"]
  id: "map-interactions"

  initialize: () ->
    _.bindAll(this, 'addOne', 'addAll', 'render')
    
    @options.territories.bind('reset', @addAll)
    @options.territories.bind('add', @addAll)
    @map = @options.map
   
  addAll: () ->
    @options.territories.each(@addOne)
  
  addOne: (territory) ->
    view = new Mapbadger.Views.Territories.TerritoryView({model : territory, map: @map, parent: this})
    terr_view = view.render().el
    @$("#saved ul#territories").append(terr_view)
    @map.displayTerritory(territory)

  renderEditTerritory: (territory) ->
    view = new Mapbadger.Views.Territories.EditView(model: territory, parent: this, map: @map)
    $(".sidebar #map-interactions").html(view.render().el)
    @map.clearTerritories()
    @map.displayTerritoryEdit(territory)

  renderSidebar: ->
    $(@el).html(@template)
    @addAll()
    $(".sidebar").prepend(@el)

  render: ->
    $(@el).html(@template)
    @addAll()
    return this
