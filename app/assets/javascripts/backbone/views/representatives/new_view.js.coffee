Mapbadger.Views.Representatives ||= {}

class Mapbadger.Views.Representatives.NewView extends Backbone.View
  template: JST["backbone/templates/representatives/new"]

  events:
    "submit #new-representative": "save"

  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    @collection.create(@model.toJSON(),
      success: (representative) =>
        @model = representative
        window.location.hash = "/#{@model.id}"

      error: (representative, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  render: ->
    $(@el).html(@template(@model.toJSON() ))

    this.$("form").backboneLink(@model)

    return this
