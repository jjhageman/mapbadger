Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.TerritoryView extends Backbone.View
  template: JST["backbone/templates/territories/territory"]
  
  events:
    "click .destroy" : "destroy"
    "click .toggle" : "toggleRegion"
    # "hover .territory" : "toggleEdit"
      
  tagName: "li"

  initialize: () ->
    @map = @options.map

  displayTerritory: ->
    if @map
      @map.clearTerritories()
      @map.displayTerritory(@model)
    view = new Mapbadger.Views.Territories.EditView(model: @model)
    $(".sidebar").html(view.render().el)

  toggleEdit: ->
    @$(".edit").toggleClass("show")

  toggleRegion: ->
    @$(".toggle").toggleClass("minus")
    @$(".regions").slideToggle(500)
  
  destroy: () ->
    @model.destroy()
    this.remove()
    
    return false
    
  render: ->
    $(@el).html(@template(@model.toJSON() ))    
    unless @model.regions.isEmpty()
      view = new Mapbadger.Views.Regions.IndexView(collection: @model.regions)
      view.hide()
      $(@el).append(view.render().el)
    return this
