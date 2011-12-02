Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.EditView extends Backbone.View
  template : JST["backbone/templates/territories/edit"]
  
  events :
    "submit #edit-territory" : "update"
    
  update : (e) ->
    e.preventDefault()
    e.stopPropagation()
    
    @model.save(null,
      success : (territory) =>
        @model = territory
        window.location.hash = "/#{@model.id}"
    )
    
  render : ->
    $(this.el).html(this.template(@model.toJSON() ))
    
    this.$("form").backboneLink(@model)
    
    return this