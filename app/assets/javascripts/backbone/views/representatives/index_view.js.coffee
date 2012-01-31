Mapbadger.Views.Representatives ||= {}

class Mapbadger.Views.Representatives.IndexView extends Backbone.View
  # template: JST["backbone/templates/representatives/index"]
  tagName: "ul"
  className: "reps"
  id: "available-reps"

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
