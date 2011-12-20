Mapbadger.Views.Territories ||= {}

class Mapbadger.Views.Territories.TerritoryView extends Backbone.View
  template: JST["backbone/templates/territories/territory"]
  
  events:
    "click .destroy" : "destroy"
    "click .toggle" : "showRegions"
      
  tagName: "li"
  className: "plus"

  showRegions: ->
    @$(".regions").slideToggle(500)
  
  destroy: () ->
    @model.destroy()
    this.remove()
    
    return false
    
  render: ->
    $(@el).html(@template(@model.toJSON() ))    
    unless @model.regions.isEmpty()
      view = new Mapbadger.Views.Regions.IndexView(collection: @model.regions)
      $(@el).append(view.render().el)
    return this
