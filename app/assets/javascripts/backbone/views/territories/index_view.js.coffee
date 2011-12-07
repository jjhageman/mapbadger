Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.IndexView extends Backbone.View
  template: JST["backbone/templates/territories/new"]
  id: "territory-form"
  className: "modal hide fade"

  events:
    "submit #new-territory": "saveTerritory"

  initialize: () ->
    _.bindAll(this, 'addOne', 'addAll', 'render', 'saveTerritory')
    
    @options.territories.bind('reset', @addAll)
    @map = new Mapbadger.Views.MapView({regions : @options.regions})
    @model = new @options.territories.model()
    @model.bind("change:errors", () =>
      this.render()
    )
   
  saveTerritory: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset("errors")

    for region in @map.regionPolys
      @model.regions.add({id: region.modelId}) if region.selected == -1

    @options.territories.create(@model,
      success: (territory) =>
        @model = territory
        $(@el).modal('hide')

      error: (territory, jqXHR) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})
    )

  addAll: () ->
    @options.territories.each(@addOne)
  
  addOne: (territory) ->
    view = new Mapbadger.Views.Territories.TerritoryView({model : territory})
    @$("tbody").append(view.render().el)
       
  render: ->
    $(".content").html(@map.render().el)
    @map.renderMap()
    # @addAll()
    $(@el).html(@template(@model.toJSON() ))
    
    @$("form").backboneLink(@model)
    
    return this
