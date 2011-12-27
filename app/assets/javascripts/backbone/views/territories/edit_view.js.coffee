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
        window.location.hash = "/#index"
    )
    
  render : ->
    $(@el).html(@template(@model.toJSON() ))
    unless @model.regions.isEmpty()
      view = new Mapbadger.Views.Regions.IndexView(collection: @model.regions)
      @$(".actions").before(view.render().el)
    
    @$("form").backboneLink(@model)
    
    return this
