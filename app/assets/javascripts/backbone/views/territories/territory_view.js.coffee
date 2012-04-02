Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.TerritoryView extends Backbone.View
  template: JST["backbone/templates/territories/territory"]
  
  events:
    "click .toggle" : "toggleRegion"
    "click .edit" : "editTerritory"
    "click .assign" : "assignTerritory"
      
  tagName: "li"

  initialize: () ->
    _.bindAll(this, 'isSelected', 'select', 'unSelect', 'showOpportunityData', 'renderSortTableHeaders', 'close')
    @map = @options.map
    @parentView = @options.parent
    @model.opportunities.bind('add', @showOpportunityData)
    @model.opportunities.bind('reset', @showOpportunityData)
    @model.opportunities.bind('remove', @showOpportunityData)
    @selected = false
    @sort_column = 'name'
    @sort_direction = 'asc'

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
      @renderSortTableHeaders()
    else
      $("#opportunity-count").empty()
      $("#territory-data table tbody").html('<tr><td colspan="5">No sales opportunities in this territory.</td></tr>')
      $("#territory-data table thead").html(JST["backbone/templates/territories/territory_data_headers"])

  renderSortTableHeaders: ->
    $("#territory-data table thead").html(JST["backbone/templates/territories/territory_data_headers"])
    $("#territory-data table th a[name=#{@.sort_column}]").addClass("current #{@.sort_direction}")
    self = this
    $('#territory-data table thead a').on('click', ->
      column = $(@).attr('name')
      self.sort_direction = if column is self.sort_column and self.sort_direction is "asc" then "desc" else "asc" 
      self.sort_column = column
      $.ajax({
        url: 'territory_opportunities.json'
        data: "territory_id=#{self.model.id}&sort=#{self.sort_column}&direction=#{self.sort_direction}"
        success: (opportunities) =>
          self.model.opportunities.reset(opportunities)
      })
      false
    )

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
