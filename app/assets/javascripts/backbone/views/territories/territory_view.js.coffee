Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.TerritoryView extends Backbone.View
  template: JST["backbone/templates/territories/territory"]
  
  events:
    "click .destroy" : "destroy"
      
  tagName: "tr"
  
  destroy: () ->
    @model.destroy()
    this.remove()
    
    return false
    
  render: ->
    $(this.el).html(@template(@model.toJSON() ))    
    return this