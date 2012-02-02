Mapbadger.Views.Representatives ||= {}

class Mapbadger.Views.Representatives.AssignView extends Backbone.View
  template: JST["backbone/templates/representatives/assign"]
  id: "assign-rep"
  className: "modal hide fade"

  events :
    "submit #assign-representative": "assign"

  update : (e) -> 
    e.preventDefault()
    e.stopPropagation()
    confirm 'got there'
    
  render : ->
    $(@el).html(@template(@model.toJSON() ))

    return this
