Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.NewView extends Backbone.View    
  template: JST["backbone/templates/territories/new"]
  id: "territory-form"
  className: "modal hide fade"
  
  events:
    "submit #new-territory": "save"
    
  constructor: (options) ->
    super(options)
    @newTerritoryRegion()
    @map = options.map

  newTerritoryRegion: ->
    @model = new @collection.model()
    @model.bind("change:errors", () =>
      this.render()
    )
    
  save: (e) ->
    e.preventDefault()
    e.stopPropagation()
      
    @model.unset("errors")

    @map.selected_polygons.each (poly) =>
      if poly.area instanceof Mapbadger.Models.Region
        @model.regions.add(poly.area, {silent: true})
      else if poly.area instanceof Mapbadger.Models.Zipcode
        @model.zipcodes.add(poly.area, {silent:true})

    @map.selected_polygons.reset()

    @collection.create(@model, 
      success: (territory) =>
        @newTerritoryRegion()
        @render()
        $(@el).modal('hide')
        
      error: (territory, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )
    
  render: ->
    $(this.el).html(@template(@model.toJSON() ))
    
    this.$("form").backboneLink(@model)
    
    return this
