class Mapbadger.Models.Opportunity extends Backbone.Model
  paramRoot: 'opportunity'
  
  address: ->
    @get("address1")+@get("city")+@get("state")

class Mapbadger.Collections.OpportunitiesCollection extends Backbone.Collection
  model: Mapbadger.Models.Opportunity
  url: 'opportunities.json'
