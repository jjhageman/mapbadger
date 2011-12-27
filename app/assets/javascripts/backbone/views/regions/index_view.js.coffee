Mapbadger.Views.Regions ||= {}

class Mapbadger.Views.Regions.IndexView extends Backbone.View
  # template: JST["backbone/templates/regions/index"]
  tagName: "ul"
  className: "regions"

  initialize: () ->
    _.bindAll(this, 'addOne', 'addAll', 'render')

  addAll: ->
    @collection.each @addOne

  addOne: (region) ->
    view = new Mapbadger.Views.Regions.RegionView(model: region)
    $(@el).append(view.render().el)

  hide: ->
    $(@el).hide()

  render: ->
    @addAll()
    
    return this
