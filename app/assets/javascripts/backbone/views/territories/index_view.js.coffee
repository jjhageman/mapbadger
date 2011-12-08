Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.IndexView extends Backbone.View
  template: JST["backbone/templates/territories/new"]
  id: "territory-form"
  className: "modal hide fade"

  events:
    "submit #new-territory": "saveTerritory"

  initialize: () ->
    _.bindAll(this, 'addOne', 'addAll', 'render', 'renderTerritories', 'saveTerritory')
    
    @options.territories.bind('reset', @addAll)
    @options.territories.bind('add', @renderTerritories)
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
      if region.selected == -1
        @model.regions.add({region_id: region.modelId})
        region.selected = @options.territories.length
        region.setOptions({
          fillColor: @map.palette[@options.territories.length%@map.palette.length]
          fillOpacity: 0.75
        })
        @map.tempSel = [[],[]]

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
    $("#territories").append(view.render().el)
       
  render: ->
    $(".content").html(@map.render().el)
    @map.renderMap()
    @renderTerritories()
    $(@el).html(@template(@model.toJSON() ))
    
    @$("form").backboneLink(@model)
    
    return this

  renderTerritories: ->
    @addAll()
    return this
