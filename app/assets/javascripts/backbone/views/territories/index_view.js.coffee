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
    @reps = @options.reps
    @territoryViews = []
   
  toggleTerritory: (territoryView) ->
    unless territoryView.isSelected()
      @deactivateTerritory view for view in @territoryViews when view isnt territoryView
      territoryView.select()
      @displayTerritoryData(territoryView.model)
      @displayTerritoryStats(territoryView.model)

  deactivateTerritory: (view) ->
    view.close()
    view.unSelect()
    
  displayTerritoryData: (territory) ->
    $.ajax({
      url: 'territory_opportunities.json'
      data: "territory_id=#{territory.id}"
      success: (opportunities) =>
        territory.opportunities.reset(opportunities)
    })
  
  displayTerritoryStats: (territory) ->
    $('#map-interactions').prepend(JST["backbone/templates/territories/territory_stats"]) unless $('#stats').length
    $('#territory-name').html(territory.get('name'))
    population = if territory.get('population')>0 then Mapbadger.Utility.formatNumber(territory.get('population')) else 'unavailable'
    $('#stats #population').html(population)
    bizPop = if territory.get('business_population')>0 then Mapbadger.Utility.formatNumber(territory.get('business_population')) else 'unavailable'
    $('#stats #biz-pop').html(bizPop)

  addAll: () ->
    @options.territories.each(@addOne)
  
  addOne: (territory) ->
    view = new Mapbadger.Views.Territories.TerritoryView({model : territory, map: @map, parent: this})
    @territoryViews.push(view)
    @$("#saved ul#territories").append(view.render().el)
    @map.displayTerritory(territory)

  renderEditTerritory: (territory) ->
    view = new Mapbadger.Views.Territories.EditView(collection: @territories, model: territory, parent: this, map: @map, reps: @reps)
    $("#sidebar #map-interactions").html(view.render().el)
    @map.clearTerritories()
    @map.displayTerritoryEdit(territory)

  renderAssignTerritory: (territory) ->
    reps = new Mapbadger.Views.Representatives.AssignView(territory: territory, reps: @reps, parent: this)
    $(@el).append(reps.render().el)

  rerender: ->
    @map.clearTerritories()
    $(@el).html(@template)
    @addAll()
    
  renderTerritoryData: ->
    $("#content").append(JST["backbone/templates/territories/territory_data"]())

  renderSidebar: ->
    @map.clearTerritories()
    $(@el).html(@template)
    @addAll()

  render: ->
    $(@el).html(@template)
    @addAll()
    @renderTerritoryData()
    #$("#sidebar #select-regions").bind("click", @selectRegions)
    @$("#reset-map").bind("click", @map.clearSel)
    @$("#saved").tooltip({
      selector: "a[rel=tooltip]"
      placement: "left"
    })
    @$("#new").tooltip({
      selector: "a[rel=tooltip]"
      placement: "left"
    })
    return this
