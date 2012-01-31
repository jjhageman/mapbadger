Mapbadger.Views.Representatives ||= {}

class Mapbadger.Views.Representatives.EditView extends Backbone.View
  template : JST["backbone/templates/representatives/edit"]

  events :
    "submit #edit-representative" : "update"

  update : (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save(null,
      success : (representative) =>
        @model = representative
        window.location.hash = "/#{@model.id}"
    )

  render : ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
