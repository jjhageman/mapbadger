Mapbadger.Views.Zipcodes ||= {}

class Mapbadger.Views.Zipcodes.IndexView extends Backbone.View
  tagName: "ul"
  className: "regions"
  id: "selected-zipcodes"

  initialize: ->
    _.bindAll(this, 'addOne', 'addAll', 'render')

  addAll: ->
    @collection.each @addOne

  addOne: (zip) ->
    view = new Mapbadger.Views.Zipcodes.ZipcodeView(model: zip)
    $(@el).append(view.render().el)

  hide: ->
    $(@el).hide()

  render: ->
    @addAll()
    return this
