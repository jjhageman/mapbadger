Mapbadger.Views.Opportunities ||= {}

class Mapbadger.Views.Opportunities.OpportunityView extends Backbone.View
  template: JST["backbone/templates/opportunities/opportunity"]

  tagName: "tr"

  render: ->
    $(@el).html(@template(@model.toJSON() ))
    return this
