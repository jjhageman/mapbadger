Mapbadger.Views.Representatives ||= {}

class Mapbadger.Views.Representatives.RepresentativeView extends Backbone.View
  template: JST["backbone/templates/representatives/representative"]

  events:
    "click .destroy" : "destroy"

  tagName: "tr"

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
