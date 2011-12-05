#= require_self
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require_tree ./routers

root = exports ? this

window.Mapbadger =
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

# var MapBadger = 
#   Models: {}
#   Collections: {}
#   Views: {}
#   Routers: {}
#   init: ->
#     new MapBadger.Routers.Territories()
#     Backbone.history.start()
