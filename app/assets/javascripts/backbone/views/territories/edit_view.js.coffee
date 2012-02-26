Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.EditView extends Backbone.View
  template : JST["backbone/templates/territories/edit"]
  
  events :
    "submit #edit-territory" : "update"
    "click .destroy" : "destroy"
    "click .cancel" : "cancel"

  initialize: ->
    @map = @options.map
    @reps = @options.reps
    @parentView = @options.parent
    @territories = @options.collection
    
  update : (e) ->
    e.preventDefault()
    e.stopPropagation()
    
    @model.regions.reset()
    @model.zipcodes.reset()
    @map.selected_polygons.each (poly) =>
      if poly.area instanceof Mapbadger.Models.Region
        @model.regions.add(poly.area, {silent: true})
      else if poly.area instanceof Mapbadger.Models.Zipcode
        @model.zipcodes.add(poly.area, {silent: true})

    @map.selected_polygons.reset()
    
    @model.save(null,
      success : (territory) =>
        @model = territory
        @parentView.rerender()
    )

  destroy: (e) ->
    e.preventDefault()
    
    if confirm "Are you sure you want to delete this territory?"
      @territories.remove(@model)

  cancel : ->
    @remove
    @parentView.rerender()
    
  render : ->
    $(@el).html(@template(@model.toJSON() ))
    reps = new Mapbadger.Views.Representatives.AssignView(territory: @model, reps: @reps, parent: @parentView)
    $(@el).append(reps.render().el)

    unless @model.regions.isEmpty()
      view = new Mapbadger.Views.Regions.IndexView(collection: @model.regions)
      @$("#selected-states").html(view.render().el)

    unless @model.zipcodes.isEmpty()
      view = new Mapbadger.Views.Zipcodes.IndexView(collection: @model.zipcodes)
      @$("#selected-states").html(view.render().el)

    @$("form#edit-territory").backboneLink(@model)
    
    return this
