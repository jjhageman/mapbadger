Mapbadger.Views.Regions ||= {}

class Mapbadger.Views.Regions.EditView extends Backbone.View
  template : JST["backbone/templates/regions/edit"]
  
  events :
    "submit #edit-region" : "update"
    
  update : (e) ->
    e.preventDefault()
    e.stopPropagation()
    
    @model.save(null,
      success : (region) =>
        @model = region
        window.location.hash = "/#{@model.id}"
    )
    
  render : ->
    $(this.el).html(this.template(@model.toJSON() ))
    
    this.$("form").backboneLink(@model)
    
    return this