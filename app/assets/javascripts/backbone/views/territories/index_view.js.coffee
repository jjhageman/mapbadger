Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.IndexView extends Backbone.View
  template: JST["backbone/templates/territories/index"]
    
  initialize: () ->
    _.bindAll(this, 'addOne', 'addAll', 'render')
    
    @options.territories.bind('reset', @addAll)
   
  addAll: () ->
    @options.territories.each(@addOne)
  
  addOne: (territory) ->
    view = new Mapbadger.Views.Territories.TerritoryView({model : territory})
    @$("tbody").append(view.render().el)
       
  render: ->
    $(@el).html(@template(territories: @options.territories.toJSON() ))
    @addAll()
    
    return this