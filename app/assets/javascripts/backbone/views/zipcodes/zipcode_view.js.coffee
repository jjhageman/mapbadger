Mapbadger.Views.Zipcodes ||= {}

class Mapbadger.Views.Zipcodes.ZipcodeView extends Backbone.View
  template: JST["backbone/templates/zipcodes/zipcode"]

  events:
    "click .destroy" : "destroy"
      
  tagName: "li"
  
  destroy: () ->
    @model.destroy()
    this.remove()
    
    return false
    
  render: ->
    $(this.el).html(@template(@model.toJSON() ))    
    return this
