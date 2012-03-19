class Mapbadger.Models.TerritoryOpportunity extends Backbone.Model
  paramRoot: 'opportunity'

class Mapbadger.Collections.TerritoryOpportunitiesCollection extends Backbone.Collection
  model: Mapbadger.Models.TerritoryOpportunity
  url: 'territory_opportunities.json'
