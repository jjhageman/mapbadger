Mapbadger.Views.Regions ||= {}

class Mapbadger.Views.Regions.ShowView extends Backbone.View
  template: JST["backbone/templates/regions/show"]
   
  render: ->
    $(this.el).html(@template(@model.toJSON() ))
    return this