Mapbadger.Views.Regions ||= {}

class Mapbadger.Views.Regions.IndexView extends Backbone.View
  template: JST["backbone/templates/regions/index"]
    
  initialize: () ->
    _.bindAll(this, 'addOne', 'addAll', 'render')
    
    @options.regions.bind('reset', @addAll)
    @regionpolys = []

    mapCenter = new google.maps.LatLng("39.8097343", "-98.5556199")

    opts =
      zoom: 4
      mapTypeId: google.maps.MapTypeId.ROADMAP
      center: mapCenter
      minZoom: 3

    @unselected_style =
      fillColor: '#AAAAAA'
      fillOpacity: 0.35
      strokeColor: '#111111'
      strokeWeight: 1
      strokeOpacity : 0.5

    @map = new google.maps.Map(document.getElementById("map-canvas"), opts)
    usBnds = new google.maps.LatLngBounds(new google.maps.LatLng(23.5,-122), new google.maps.LatLng(76,-65))
    @map.fitBounds(usBnds)
    # boxselmrk = new google.maps.Marker({draggable:true, clickable: true, position: new google.maps.LatLng(0,0), icon :mrkimage, map : gmap, raiseOnDrag : false })
    # infoWindow = new google.maps.InfoWindow()
    window.map = @map
    window.regionPolys = @regionpolys

  addAll: () ->
    @options.regions.each(@addOne)
  
  addOne: (region) ->
    polybnd = null
    paths = []
    rname = region.get('name')
    rcode = region.get('fipscode')
    coords = region.get('coords').split('~')
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

      kk = @regionpolys.length
      @regionpolys.push(new google.maps.Polygon({paths:paths , map: @map , clickable : false , code:rcode, name:rname , id:kk, bnd:polybnd, selected : 0}))
      @regionpolys[kk].setOptions(@unselected_style)
       
  render: ->
    $(@el).html(@template(regions: @options.regions.toJSON() ))
    @addAll()
    
    return this
