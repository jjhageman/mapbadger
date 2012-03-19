Mapbadger.Views.Opportunities ||= {}

class Mapbadger.Views.Opportunities.IndexView extends Backbone.View
  tagName: "tbody"
  
  initialize: ->
    _.bindAll(this, 'addOne', 'addAll', 'render')

  addOne: (opportunity) ->
    view = new Mapbadger.Views.Opportunities.OpportunityView({model: opportunity})
    $(@el).append(view.render().el)
    
  addAll: ->
    @collection.each(@addOne)

  render: ->
    @addAll()
    return this
