Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.NewView extends Backbone.View    
  template: JST["backbone/templates/territories/new"]
  id: "territory-form"
  className: "modal hide fade"
  
  events:
    "submit #new-territory": "save"
    
  constructor: (options) ->
    super(options)
    @model = new @collection.model()

    @model.bind("change:errors", () =>
      this.render()
    )
    @map = options.map
    
  save: (e) ->
    e.preventDefault()
    e.stopPropagation()
      
    @model.unset("errors")

    @map.selected_polygons.each (poly) =>
      # poly.select()
      # poly.google_poly.setOptions({
      #   fillColor: @map.palette[@collection.length%@map.palette.length]
      #   fillOpacity: 0.75
      # })
      @model.regions.add({region_id: poly.id}, {silent: true})
    @map.selected_polygons.reset()

      # if region.selected == -1
      #   @model.regions.add({region_id: region.modelId})
      #   region.selected = @collection.length
      #   region.setOptions({
      #     fillColor: @map.palette[@collection.length%@map.palette.length]
      #     fillOpacity: 0.75
      #   })
      #   @map.tempSel = [[],[]]
    
    @collection.create(@model, 
      success: (territory) =>
        @model = territory
        $(@el).modal('hide')
        
      error: (territory, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )
    
  render: ->
    $(this.el).html(@template(@model.toJSON() ))
    
    this.$("form").backboneLink(@model)
    
    return this
