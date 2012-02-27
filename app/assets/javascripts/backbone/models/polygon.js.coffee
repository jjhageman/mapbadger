class Mapbadger.Models.Polygon extends Backbone.Model
  initialize: ->
    @setArea(@get('area'))
    @area.set({polygon: this})
    # @id = @area.id
    @map = @get('map')
    #@name = @area.get('name')
    #if @region instanceof Mapbadger.Models.Region
      #@fips = @region.get('fipscode')
      #coords = @region.get('coords').split('~')
      #paths = []
      #polyBnd = null
      #for parts, ii in coords
        #coordArr = parts.split('|')
        #paths.push([])
        #baseLat = 0
        #baseLng = 0
        #for arr in coordArr
          #point = arr.split(',')
          #baseLat += parseInt(point[0],36)/10000.0
          #baseLng += parseInt(point[1],36)/10000.0
          #newPnt = new google.maps.LatLng(baseLat,baseLng)
          #if !polybnd
            #polybnd = new google.maps.LatLngBounds(newPnt,newPnt)
          #else
            #polybnd.extend(newPnt)

          #paths[ii].push(newPnt)
    #else if @region instanceof Mapbadger.Models.Zipcode

    paths = @area.geometries.invoke 'paths'

    @google_poly = new google.maps.Polygon({
      paths: paths
      map: @map
      #bnd: polybnd
      clickable: @get('clickable')
    })

  defaults:
    clickable: true
    selected: 0

  setArea: (area) ->
    @area = area

  isSelected: ->
    @get('selected') == -1

  select: ->
    @set({selected: -1})

  unSelect: ->
    @set({selected: 0}) 
  
class Mapbadger.Collections.PolygonsCollection extends Backbone.Collection
  model: Mapbadger.Models.Polygon
