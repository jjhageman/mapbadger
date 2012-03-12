Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.TerritoryView extends Backbone.View
  template: JST["backbone/templates/territories/territory"]
  
  events:
    "click .toggle" : "toggleRegion"
    "click .edit" : "editTerritory"
      
  tagName: "li"

  initialize: () ->
    @map = @options.map
    @parentView = @options.parent

  editTerritory: ->
    @parentView.renderEditTerritory(@model)

  toggleEdit: ->
    @$(".edit").toggleClass("show")

  toggleRegion: ->
    @$(".toggle i").toggleClass("icon-plus-sign")
    @$(".toggle i").toggleClass("icon-minus-sign")
    @$(".regions").slideToggle(500)
  
    
  render: ->
    $(@el).html(@template(@model.toJSON() ))

    $(@el).find('.rep').html(" - "+@model.rep.name()) if @model.rep

    unless @model.regions.isEmpty()
      view = new Mapbadger.Views.Regions.IndexView(collection: @model.regions)
      view.hide()
      $(@el).append(view.render().el)

    unless @model.zipcodes.isEmpty()
      zView = new Mapbadger.Views.Zipcodes.IndexView(collection: @model.zipcodes)
      zView.hide()
      $(@el).append(zView.render().el)

    return this
