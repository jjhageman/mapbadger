class Mapbadger.Views.MapView extends Backbone.View
  id: 'map-container'

  events:
    "click #select-regions": "selectRegions",
    "click #reset-map": "clearSel"

  initialize: () ->
    _.bindAll(this, 'addOne', 'addAll', 'render')
    @zoom = 4
    @mapTypeId = google.maps.MapTypeId.ROADMAP
    @minZoom = 3
    
    @opts =
      zoom: @zoom
      mapTypeId: @mapTypeId
      center: @mapCenter
      minZoom: @minZoom

    @regionPolys = []
    @startPt = ''
    @endPt = ''
    @rect = ''
    @mrkImage = ''
    @selMarker = ''
    @lstnr = ''
    @tempSel = [[],[]]

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
    
  render: ->
    $(@el).html(JST["backbone/templates/maps/map"]())
    return this

  renderMap: ->
    @map = new google.maps.Map(document.getElementById("map-canvas"), @opts)
    @usBnds = new google.maps.LatLngBounds(new google.maps.LatLng(23.5,-122), new google.maps.LatLng(76,-65))
    @map.fitBounds(@usBnds)
    @addAll()
    return

  clearSel: ->
    for poly in @regionPolys
      if poly.selected == -1
        poly.setOptions(@unselected_style)
        poly.selected = 0
    @tempSel = [[],[]]
    $('#selected-states').empty()

  selectRegions: ->
    @markerImg = new google.maps.MarkerImage("rails.png", new google.maps.Size(24,24), new google.maps.Point(0,0), new google.maps.Point(12,12), new google.maps.Size(24,24))
    @selMarker = new google.maps.Marker
      draggable: true
      clickable: true
      position: new google.maps.LatLng(0,0)
      icon: @markerImg
      map: @map
      raiseOnDrag: false

    google.maps.event.addListener @selMarker, 'dragstart', (event) =>
      @startRect(event.latLng)
    google.maps.event.addListener @selMarker, 'drag', (event) =>
      @drawRect(event.latLng)
    google.maps.event.addListener @selMarker, 'dragend', (event) =>
      @getSel(event.latLng)
    @lstnr = google.maps.event.addListener @map, 'mousemove', (event) =>
      @selMarker.setPosition(event.latLng)
    return

  startRect: (ll) ->
    @startPt = ll
    @rect = new google.maps.Rectangle 
      bounds:new google.maps.LatLngBounds(ll,ll)
      fillColor: '#0000FF'
      fillOpacity: 0.05
      strokeColor: '#0000FF'
      strokeOpacity: 1
      strokeWeight: 1
      map: @map
    return

  drawRect: (ll) ->
    tempBnd = new google.maps.LatLngBounds @startPt,@startPt
    tempBnd.extend ll
    @rect.setBounds tempBnd
    return

  getSel: (ll) ->
    @endPt = ll
    tempBnd = new google.maps.LatLngBounds @startPt,@startPt
    tempBnd.extend ll
    @rect.setBounds tempBnd
    @rect.setMap null
    rectBnd = @rect.getBounds()
    for polys, ii in @regionPolys
      if rectBnd.contains(@regionPolys[ii].bnd.getSouthWest()) && rectBnd.contains(@regionPolys[ii].bnd.getNorthEast())
        if @regionPolys[ii].selected == 0
          @tempSel[0].push ii
          @tempSel[1].push @regionPolys[ii].code
          @regionPolys[ii].setOptions(@selected_style)
          @regionPolys[ii].selected = -1
    @refreshList()
    google.maps.event.clearInstanceListeners @selMarker
    google.maps.event.removeListener @lstnr
    @selMarker.setMap null
    
  clearSel: ->
    for poly in @regionPolys
      if poly.selected == -1
        poly.setOptions(@unselected_style)
        poly.selected = 0
    @tempSel = [[],[]]
    $('#selected-states').empty()

  refreshList: ->
    $('#selected-states').empty()
    for poly in @regionPolys
      $('#selected-states').append("<li>"+poly.name+"</li>") if poly.selected == -1

  addState: (id) ->
    if @regionPolys[id].selected == 0
      @tempSel[0].push id
      @tempSel[1].push @regionPolys[id].code
      @regionPolys[id].setOptions @selected_style
      @regionPolys[id].selected = -1
      @refreshList()
    else
      if @regionPolys[id].selected == -1
        for selection, jj in @tempSel[0]
          if selection == id
            @tempSel[0].splice(jj,1)
            @tempSel[1].splice(jj,1)
        @regionPolys[id].setOptions @unselected_style
        @regionPolys[id].selected = 0
        @refreshList()

  addAll: () ->
    @options.regions.each(@addOne)
  
  addOne: (region) ->
    polybnd = null
    paths = []
    rname = region.get('name')
    rcode = region.get('fipscode')
    rid = region.get('id')
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

      self = this;
      kk = @regionPolys.length
      @regionPolys.push(new google.maps.Polygon({paths:paths , map: @map , clickable : true , modelId:rid, code:rcode, name:rname , id:kk, bnd:polybnd, selected : 0}))
      google.maps.event.addListener(@regionPolys[kk], 'click', -> self.addState(@id))
      @regionPolys[kk].setOptions(@unselected_style)
