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
    color = @map.nextColor()
    territory.regions.each (reg) =>
      region_id = reg.id || reg.get("region_id")
      poly = @map.polygons.get(region_id)
      poly.select()
      poly.google_poly.setOptions({
        fillColor: color
        fillOpacity: 0.75
        clickable: false
      })

  render: ->
    $(".content").html(@map.render().el)
    @map.renderMap()
    @addAll()
    # $(@el).html(@template(@model.toJSON() ))
    $(".sidebar").append(@territoryForm.render().el)
    
    return this
