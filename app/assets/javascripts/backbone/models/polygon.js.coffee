class Mapbadger.Models.Polygon extends Backbone.Model
  initialize: ->
    @selected_style = 
      fillColor: '#FF6633'
      fillOpacity: 0.35
      strokeColor: '#111111'
      strokeWeight: 1
      strokeOpacity : 0.5

    @unselected_style = 
      fillColor: '#AAAAAA'
      fillOpacity:0.35
      strokeColor: '#111111'
      strokeWeight: 1
      strokeOpacity: 0.5

    @region = @get('region')
    @name = @region.get('name')
    @fips = @region.get('fipscode')
    coords = @region.get('coords').split('~')
    paths = []
    polyBnd = null
    for parts, ii in coords
      coordArr = parts.split('|')
      paths.push([])
      baseLat = 0
      baseLng = 0
      for arr in coordArr
        point = arr.split(',')
        baseLat += parseInt(point[0],36)/10000.0
        baseLng += parseInt(point[1],36)/10000.0
        newPnt = new google.maps.LatLng(baseLat,baseLng)
        if !polybnd
          polybnd = new google.maps.LatLngBounds(newPnt,newPnt)
        else
          polybnd.extend(newPnt)

        paths[ii].push(newPnt)

    @google_poly = new google.maps.Polygon({
      paths: paths
      map: @map
      clickable: @clickable
    })
    @google_poly.setOptions(@unselected_style)

  defaults:
    clickable: true
    selected: 0
  
class Mapbadger.Collections.PolygonsCollection extends Backbone.Collection
  model: Mapbadger.Models.Polygon
