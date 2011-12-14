class Mapbadger.Models.Polygon extends Backbone.Model
  initialize: ->
    @region = @get('region')
    @region.set({polygon: this})
    @map = @get('map')
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
      bnd: polybnd
      clickable: @get('clickable')
    })

  defaults:
    clickable: true
    selected: 0

  isSelected: ->
    @get('selected') == -1

  select: ->
    @set({selected: -1})

  unSelect: ->
    @set({selected: 0}) 
  
class Mapbadger.Collections.PolygonsCollection extends Backbone.Collection
  model: Mapbadger.Models.Polygon
