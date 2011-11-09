Mapbadger.Views.Regions ||= {}

class Mapbadger.Views.Regions.RegionView extends Backbone.View
  template: JST["backbone/templates/regions/region"]
  
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