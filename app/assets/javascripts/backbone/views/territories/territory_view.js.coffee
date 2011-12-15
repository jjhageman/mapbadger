Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.TerritoryView extends Backbone.View
  template: JST["backbone/templates/territories/territory"]
  
  events:
    "click .destroy" : "destroy"
    "click .territory" : "showRegions"
      
  tagName: "li"
  className: "territory"

  showRegions: ->
    this.next(".regions").slideToggle(500)
  
  destroy: () ->
    @model.destroy()
    this.remove()
    
    return false
    
  render: ->
    $(@el).html(@template(@model.toJSON() ))    
    unless @model.regions.isEmpty()
      view = new Mapbadger.Views.Regions.IndexView(collection: @model.regions)
      $(@el).append(view.render().el)
    $(@el).click () =>
      @$(".regions").slideToggle(500)
    return this
