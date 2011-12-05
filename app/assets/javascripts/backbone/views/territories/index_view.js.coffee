Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.IndexView extends Backbone.View
    
  initialize: () ->
    _.bindAll(this, 'addOne', 'addAll', 'render')
    
    @options.territories.bind('reset', @addAll)
    @map = new Mapbadger.Views.MapView({regions : @options.regions})
   
  saveSelect: ->
    alert('save select')

  addAll: () ->
    @options.territories.each(@addOne)
  
  addOne: (territory) ->
    view = new Mapbadger.Views.Territories.TerritoryView({model : territory})
    @$("tbody").append(view.render().el)
       
  render: ->
    $(".content").html(@map.render().el)
    @map.renderMap()
    $("#save-select").bind("click", @saveSelect)
    @addAll()
    
    return this
