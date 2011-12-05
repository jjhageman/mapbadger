Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.NewView extends Backbone.View    
  template: JST["backbone/templates/territories/new"]
  
  events:
    "submit #new-territory": "save"
    
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
      success: (territory) =>
        @model = territory
        window.location.hash = "/#{@model.id}"
        
      error: (territory, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )
    
  render: ->
    $(this.el).html(@template(@model.toJSON() ))
    
    this.$("form").backboneLink(@model)
    
    return this
