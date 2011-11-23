startPt = ''
endPt = ''
rect = ''
mrkImage = ''
boxSelMrk = ''
lstnr = ''
tempSel = [[],[]]
selected_style =
  fillColor: '#FF6633'
  fillOpacity: 0.35
  strokeColor: '#111111'
  strokeWeight: 1
  strokeOpacity : 0.5

@regionPolys = window.regionPolys

startRect = (ll) ->
  startPt = ll
  rect = new google.maps.Rectangle 
    bounds:new google.maps.LatLngBounds(ll,ll)
    fillColor: '#0000FF'
    fillOpacity: 0.05
    strokeColor: '#0000FF'
    strokeOpacity: 1
    strokeWeight: 1
    map: window.map
  return

drawRect = (ll) ->
  tempBnd = new google.maps.LatLngBounds startPt,startPt
  tempBnd.extend ll
  rect.setBounds tempBnd
  return

getSel = (ll) ->
  endPt = ll
  tempBnd = new google.maps.LatLngBounds startPt,startPt
  tempBnd.extend ll
  rect.setBounds tempBnd
  rect.setMap null
  rectBnd = rect.getBounds()
  for polys, ii in @regionPolys
    if rectBnd.contains(@regionPolys[ii].bnd.getSouthWest()) && rectBnd.contains(@regionPolys[ii].bnd.getNorthEast())
      if @regionPolys[ii].selected == 0
        tempSel[0].push ii
        tempSel[1].push @regionPolys[ii].code
        @regionPolys[ii].setOptions(selected_style)
        @regionPolys[ii].selected = -1
  refreshList()
  google.maps.event.clearInstanceListeners boxSelMrk
  google.maps.event.removeListener lstnr
  boxSelMrk.setMap null
  
refreshList = ->
  $('#selected-states').empty
  for poly in @regionPolys
    $('#selected-states').append poly.name if poly.selected == -1

$(document).ready ->
  mrkImage = new google.maps.MarkerImage("../images/rails.png", new google.maps.Size(24,24), new google.maps.Point(0,0),new google.maps.Point(12,12),new google.maps.Size(24,24))
  boxSelMrk = new google.maps.Marker
    draggable: true
    clickable: true
    position: new google.maps.LatLng(0,0)
    icon: mrkImage
    map: window.map
    raiseOnDrag: false

  $('#select-regions').click ->
    mrkImage = new google.maps.MarkerImage("../images/rails.png", new google.maps.Size(24,24), new google.maps.Point(0,0),new google.maps.Point(12,12),new google.maps.Size(24,24))
    boxSelMrk = new google.maps.Marker
      draggable: true
      clickable: true
      position: new google.maps.LatLng(0,0)
      icon: mrkImage
      map: window.map
      raiseOnDrag: false

    google.maps.event.addListener boxSelMrk, 'dragstart', (event) =>
      startRect(event.latLng)
    google.maps.event.addListener boxSelMrk, 'drag', (event) =>
      drawRect(event.latLng)
    google.maps.event.addListener boxSelMrk, 'dragend', (event) =>
      getSel(event.latLng)
    lstnr = google.maps.event.addListener window.map, 'mousemove', (event) =>
      boxSelMrk.setPosition(event.latLng)
    return
