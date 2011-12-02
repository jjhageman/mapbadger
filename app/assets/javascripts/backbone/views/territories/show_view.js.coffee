Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.ShowView extends Backbone.View
  template: JST["backbone/templates/territories/show"]
   
  render: ->
    $(this.el).html(@template(@model.toJSON() ))
    return this