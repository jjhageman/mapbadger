Mapbadger.Views.Representatives ||= {}

class Mapbadger.Views.Representatives.ShowView extends Backbone.View
  template: JST["backbone/templates/representatives/show"]

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
