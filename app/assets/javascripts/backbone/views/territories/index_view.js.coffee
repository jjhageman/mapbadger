Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.IndexView extends Backbone.View
  # template: JST["backbone/templates/territories/index"]
  tagName: "ul"
  id: "territories"

  initialize: () ->
    _.bindAll(this, 'addOne', 'addAll', 'render')
    
    @options.territories.bind('reset', @addAll)
    @options.territories.bind('add', @addAll)
    @map = new Mapbadger.Views.MapView({regions : @options.regions})
    @territoryForm = new Mapbadger.Views.Territories.NewView(collection: @options.territories, map: @map)
   
  addAll: () ->
    @options.territories.each(@addOne)
  
  addOne: (territory) ->
    view = new Mapbadger.Views.Territories.TerritoryView({model : territory})
    $(@el).append(view.render().el)
    territory.regions.each (reg) =>
      @map.polygons.find( (p) =>
        
      )

      # region = _.find(@map.regionPolys, (r) =>
      #   r.modelId == reg.id
      # )
      # region.selected = @options.territories.length
      # region.setOptions({
      #   fillColor: @map.palette[@options.territories.length%@map.palette.length]
      #   fillOpacity: 0.75
      # })

       
  render: ->
    $(".content").html(@map.render().el)
    @map.renderMap()
    @addAll()
    # $(@el).html(@template(@model.toJSON() ))
    $(".sidebar").append(@territoryForm.render().el)
    
    return this
