$(document).ready ->
  $('#select-regions').click ->
    mrkimage = new google.maps.MarkerImage("./test.PNG", new google.maps.Size(24,24), new google.maps.Point(0,0),new google.maps.Point(12,12),new google.maps.Size(24,24))
    boxselMrk = new google.maps.Marker ({draggable:true, clickable: true, position: new google.maps.LatLng(0,0), icon :mrkimage, map : gmap, raiseOnDrag : false })
    google.maps.event.addListener boxSelMrk, 'dragstart', (event) =>
      startrect(event.latLng)

startRect = (ll) ->
  rect = new google.maps.Rectangle 
    bounds:new google.maps.LatLngBounds(ll,ll)
    fillColor: '#0000FF'
    fillOpacity: 0.05
    strokeColor: '#0000FF'
    strokeOpacity: 1
    strokeWeight: 1
    map: gmap
  return
