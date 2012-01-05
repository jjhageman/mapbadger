Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.IndexView extends Backbone.View
  template: JST["backbone/templates/territories/index"]
  id: "map-interactions"

  initialize: () ->
    _.bindAll(this, 'addOne', 'addAll', 'render', 'rerender')
    @territories = @options.territories
    @options.territories.bind('remove', @rerender) 
    @options.territories.bind('reset', @addAll)
    @options.territories.bind('add', @addOne)
    @map = @options.map
   
  addAll: () ->
    @options.territories.each(@addOne)
  
  addOne: (territory) ->
    view = new Mapbadger.Views.Territories.TerritoryView({model : territory, map: @map, parent: this})
    @$("#saved ul#territories").append(view.render().el)
    @map.displayTerritory(territory)

  renderEditTerritory: (territory) ->
    view = new Mapbadger.Views.Territories.EditView(collection: @territories, model: territory, parent: this, map: @map)
    $(".sidebar #map-interactions").html(view.render().el)
    @map.clearTerritories()
    @map.displayTerritoryEdit(territory)

  rerender: ->
    @map.clearTerritories()
    $(@el).html(@template)
    @addAll()
    
  renderSidebar: ->
    @map.clearTerritories()
    $(@el).html(@template)
    @addAll()

  render: ->
    $(@el).html(@template)
    @addAll()
    return this
