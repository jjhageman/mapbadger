Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.TerritoryView extends Backbone.View
  template: JST["backbone/templates/territories/territory"]
  
  events:
    "click .toggle" : "toggleRegion"
    "click .edit" : "editTerritory"
    "click .assign" : "assignTerritory"
      
  tagName: "li"

  initialize: () ->
    _.bindAll(this, 'isSelected', 'select', 'unSelect', 'showOpportunityData', 'close')
    @map = @options.map
    @parentView = @options.parent
    @model.opportunities.bind('add', @showOpportunityData)
    @model.opportunities.bind('reset', @showOpportunityData)
    @model.opportunities.bind('remove', @showOpportunityData)
    @selected = false

  isSelected: ->
    @selected

  select: ->
    @$(".header").addClass("active")
    @selected = true

  unSelect: ->
    @$(".header").removeClass("active")
    @selected = false

  showOpportunityData: ->
    if @model.opportunities.length > 0
      view = new Mapbadger.Views.Opportunities.IndexView(collection: @model.opportunities)
      $("#opportunity-count").html("Number of records: "+@model.opportunities.length)
      $("#territory-data table tbody").replaceWith(view.render().el)
    else
      $("#opportunity-count").empty()
      $("#territory-data table tbody").html('<tr><td colspan="5">No sales opportunities in this territory.</td></tr>')

  editTerritory: ->
    @parentView.renderEditTerritory(@model)

  assignTerritory: ->
    @parentView.renderAssignTerritory(@model)

  toggleEdit: ->
    @$(".edit").toggleClass("show")

  toggleRegion: ->
    @parentView.toggleTerritory(@)
    @$(".toggle i").toggleClass("icon-plus-sign")
    @$(".toggle i").toggleClass("icon-minus-sign")
    @$(".regions").slideToggle(500)
  
  close: ->
    @$("toggle i").addClass("icon-plus-sign")
    @$("toggle i").addClass("icon-minus-sign")
    @$(".regions").slideUp(250)
    
  render: ->
    $(@el).html(@template(@model.toJSON() ))

    $(@el).find('.assign').html(@model.rep.name()) if @model.rep

    unless @model.regions.isEmpty()
      view = new Mapbadger.Views.Regions.IndexView(collection: @model.regions)
      view.hide()
      $(@el).append(view.render().el)

    unless @model.zipcodes.isEmpty()
      zView = new Mapbadger.Views.Zipcodes.IndexView(collection: @model.zipcodes)
      zView.hide()
      $(@el).append(zView.render().el)

    return this
