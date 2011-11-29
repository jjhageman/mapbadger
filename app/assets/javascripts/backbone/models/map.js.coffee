class Mapbadger.Models.Map extends Backbone.Model
  zoom: 4
  mapTypeId: google.maps.MapTypeId.ROADMAP
  minZoom: 3
  mapCenter: new google.maps.LatLng("39.8097343", "-98.5556199")

  initialize: () ->
    @opts =
      zoom: @zoom
      mapTypeId: @mapTypeId
      center: @mapCenter
      minZoom: @minZoom
    
    @canvas = $("#map-canvas")
    @map = new google.maps.Map(document.getElementById("map-canvas"), @opts)
    @usBnds = new google.maps.LatLngBounds(new google.maps.LatLng(23.5,-122), new google.maps.LatLng(76,-65))
    @map.fitBounds(@usBnds)

