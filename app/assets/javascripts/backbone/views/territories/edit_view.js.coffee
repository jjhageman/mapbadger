Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.EditView extends Backbone.View
  template : JST["backbone/templates/territories/edit"]
  
  events :
    "submit #edit-territory" : "update"
    "click .cancel" : "cancel"

  initialize: ->
    @map = @options.map
    @parentView = @options.parent
    
  update : (e) ->
    e.preventDefault()
    e.stopPropagation()
    
    @model.regions.reset()
    @map.selected_polygons.each (poly) =>
      @model.regions.add(poly.region, {silent: true})

    @map.selected_polygons.reset()
    
    @model.save(null,
      success : (territory) =>
        @model = territory
        @options.parent.renderSidebar()
    )

  cancel : ->
    @parentView.renderSidebar()
    
  render : ->
    $(@el).html(@template(@model.toJSON() ))
    unless @model.regions.isEmpty()
      view = new Mapbadger.Views.Regions.IndexView(collection: @model.regions)
      @$(".actions").before(view.render().el)
    
    @$("form").backboneLink(@model)
    
    return this
