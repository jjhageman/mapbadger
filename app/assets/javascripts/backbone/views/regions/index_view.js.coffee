Mapbadger.Views.Regions ||= {}

class Mapbadger.Views.Regions.IndexView extends Backbone.View
  template: JST["backbone/templates/regions/index"]
    
  initialize: () ->
    _.bindAll(this, 'addOne', 'addAll', 'render')
    
    @options.regions.bind('reset', @addAll)
   
  addAll: () ->
    @options.regions.each(@addOne)
  
  addOne: (region) ->
    view = new Mapbadger.Views.Regions.RegionView({model : region})
    @$("tbody").append(view.render().el)
       
  render: ->
    $(@el).html(@template(regions: @options.regions.toJSON() ))
    @addAll()
    
    return this