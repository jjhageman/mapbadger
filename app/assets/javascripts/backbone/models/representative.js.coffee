class Mapbadger.Models.Representative extends Backbone.Model
  paramRoot: 'representative'

  name: ->
    @get('first_name') + @get('last_name')

class Mapbadger.Collections.RepresentativesCollection extends Backbone.Collection
  model: Mapbadger.Models.Representative
  url: '/representatives'
