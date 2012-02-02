Mapbadger.Views.Representatives ||= {}

class Mapbadger.Views.Representatives.IndexView extends Backbone.View
  # template: JST["backbone/templates/representatives/index"]
  tagName: "select"
  className: "reps"
  id: "available-reps"
  attributes:
    size: "5"

  initialize: () ->
    _.bindAll(this, 'addOne', 'addAll', 'render')

  addAll: () =>
    @collection.each @addOne

  addOne: (rep) =>
    view = new Mapbadger.Views.Representatives.RepresentativeView({model : rep})
    $(@el).append(view.render().el)

  render: =>
    @addAll()

    return this
