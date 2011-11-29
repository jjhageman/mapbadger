class Mapbadger.Views.MapView extends Backbone.View
  initialize: () ->
    _.bindAll(this, 'render')
    @zoom = 4
    @mapTypeId = google.maps.MapTypeId.ROADMAP
    @minZoom = 3
    
    @opts =
      zoom: @zoom
      mapTypeId: @mapTypeId
      center: @mapCenter
      minZoom: @minZoom
    
  render: ->
    @canvas = $("#map-canvas")
    @map = new google.maps.Map(document.getElementById("map-canvas"), @opts)
    @usBnds = new google.maps.LatLngBounds(new google.maps.LatLng(23.5,-122), new google.maps.LatLng(76,-65))
    @map.fitBounds(@usBnds)
    return this
