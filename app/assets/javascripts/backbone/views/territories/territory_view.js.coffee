Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.TerritoryView extends Backbone.View
  template: JST["backbone/templates/territories/territory"]
  
  events:
    "click .toggle" : "toggleRegion"
    "click .territory" : "editTerritory"
    "hover .territory" : "toggleEdit"
      
  tagName: "li"

  initialize: () ->
    @map = @options.map
    @parentView = @options.parent

  editTerritory: ->
    @parentView.renderEditTerritory(@model)

  toggleEdit: ->
    @$(".edit").toggleClass("show")

  toggleRegion: ->
    @$(".toggle").toggleClass("minus")
    @$(".regions").slideToggle(500)
  
    
  render: ->
    $(@el).html(@template(@model.toJSON() ))    
    unless @model.regions.isEmpty()
      view = new Mapbadger.Views.Regions.IndexView(collection: @model.regions)
      view.hide()
      $(@el).append(view.render().el)
    return this
