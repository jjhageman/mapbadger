Mapbadger.Views.Regions ||= {}

class Mapbadger.Views.Regions.NewView extends Backbone.View    
  template: JST["backbone/templates/regions/new"]
  
  events:
    "submit #new-region": "save"
    
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
      success: (region) =>
        @model = region
        window.location.hash = "/#{@model.id}"
        
      error: (region, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )
    
  render: ->
    $(this.el).html(@template(@model.toJSON() ))
    
    this.$("form").backboneLink(@model)
    
    return this