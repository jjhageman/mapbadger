Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.EditView extends Backbone.View
  template : JST["backbone/templates/territories/edit"]
  
  events :
    "submit #edit-territory" : "update"
    "click .destroy" : "destroy"
    "click .cancel" : "cancel"

  initialize: ->
    @map = @options.map
    @parentView = @options.parent
    @territories = @options.collection
    
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
        @parentView.renderSidebar()
    )

  destroy: (e) ->
    e.preventDefault()
    
    if confirm "Are you sure you want to delete this territory?"
      @territories.remove(@model)
      # @parentView.renderSidebar()

  cancel : ->
    @remove
    @parentView.renderSidebar()
    
  render : ->
    $(@el).html(@template(@model.toJSON() ))
    unless @model.regions.isEmpty()
      view = new Mapbadger.Views.Regions.IndexView(collection: @model.regions)
      @$(".actions").before(view.render().el)
    
    @$("form").backboneLink(@model)
    
    return this
