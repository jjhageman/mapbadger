class Mapbadger.Views.MapView extends Backbone.View
  id: 'map-container'

  events:
    "click .add-heat" : "addHeat"
    "click .remove-heat" : "removeHeat"

  initialize: () ->
    _.bindAll(this, 'addOne', 'addHidden', 'createPoly', 'clearSel', 'addAll', 'render', 'displayAreaForSaved', 'displayAreaForEdit', 'addHeat', 'removeHeat')
    @zoom = 4
    @showingZips = false
    @mapTypeId = google.maps.MapTypeId.ROADMAP
    @minZoom = 3
    
    @opts =
      zoom: @zoom
      mapTypeId: @mapTypeId
      center: @mapCenter
      minZoom: @minZoom

    @zip_states = new Mapbadger.Collections.RegionsCollection()
    @polygons = new Mapbadger.Collections.PolygonsCollection()
    @selected_polygons = new Mapbadger.Collections.PolygonsCollection()
    @selected_polygons.bind("add", @refreshList, this)
    @selected_polygons.bind("remove", @refreshList, this)
    @selected_polygons.bind("reset", @refreshList, this)

    @startPt = ''
    @endPt = ''
    @rect = ''
    @mrkImage = ''
    @selMarker = ''
    @lstnr = ''

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
      clickable: true

    @edit_style =
      fillColor: '#777777'
      fillOpacity: 0.75
      clickable: true

    @palette = ['#AA00A2','#0A64A4','#FF9700','#7F207B','#24577B','#BF8530','#6E0069','#03406A','#A66200','#D435CD','#3E94D1','#FFB140','#D460CF','#65A5D1','#FFC673','#808000','#00FF00','#008000']
    @palette_pointer = 0

  render: ->
    $(@el).html(JST["backbone/templates/maps/map"]())
    $(@el).prepend(JST["backbone/templates/maps/loading"]())
    return this

  nextColor: ->
    @palette_pointer = 0 if @palette_pointer >= @palette.length
    color = @palette[@palette_pointer]
    @palette_pointer++
    color

  renderMap: ->
    @map = new google.maps.Map(document.getElementById("map-canvas"), @opts)
    @usBnds = new google.maps.LatLngBounds(new google.maps.LatLng(23.5,-122), new google.maps.LatLng(76,-65))
    @map.fitBounds(@usBnds)
    @heatmap = new HeatmapOverlay(@map, {"radius":25, "visible":true, "opacity":60})
    @addAll()
    #@addHeat()
    google.maps.event.addListener @map, 'zoom_changed', (event) =>
      zoomLevel = @map.getZoom()
      if not @showingZips and zoomLevel >= 8
        $(".overlaymessage").show()
        @showZips()
      else if @showingZips and zoomLevel < 8
        $(".overlaymessage").show()
        @hideZips()
      google.maps.event.addListener @map, 'idle', (event) => 
        $(".overlaymessage").hide()
    return

  showZips: ->
    bb = @map.getBounds().toString()
    @zip_states.each (state) ->
      state.get('polygon').google_poly.setVisible false
      state.zipcodes.each (zipcode) ->
        zipcode.get('polygon').google_poly.setVisible true

    @showingZips = true

  hideZips: ->
    @zip_states.each (state) ->
      state.get('polygon').google_poly.setVisible true
      state.zipcodes.each (zipcode) ->
        zipcode.get('polygon').google_poly.setVisible false

    @showingZips = false

  clearTerritories: ->
    @selected_polygons.reset()
    @polygons.each (ply) =>
      ply.google_poly.setOptions(@unselected_style)
      ply.unSelect()

  displayAreaForEdit: (area) ->
    if area instanceof Mapbadger.Models.Region
      poly = @polygons.get('r'+area.id)
    else if area instanceof Mapbadger.Models.Zipcode
      poly = @polygons.get('z'+area.id)

    poly.select()
    @selected_polygons.add(poly)
    poly.google_poly.setOptions(@edit_style)

  displayTerritoryEdit: (territory) ->
    territory.regions.each(@displayAreaForEdit)
    # TODO zoom to zipcodes bounding box
    territory.zipcodes.each(@displayAreaForEdit)

  displayAreaForSaved: (area, color) ->
    if area instanceof Mapbadger.Models.Region
      poly = @polygons.get('r'+area.id)
    else if area instanceof Mapbadger.Models.Zipcode
      poly = @polygons.get('z'+area.id)

    poly.select()
    poly.google_poly.setOptions({
      fillColor: color
      fillOpacity: 0.75
      clickable: false
    })

  displayTerritory: (territory) ->
    color = @nextColor()
    territory.regions.each (region) =>
      @displayAreaForSaved(region, color)
    territory.zipcodes.each (zipcode) =>
      @displayAreaForSaved(zipcode, color)

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

  getZips: (bb) ->

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
    @polygons.each (poly) =>
      if rectBnd.contains(poly.google_poly.bnd.getSouthWest()) && rectBnd.contains(poly.google_poly.bnd.getNorthEast())
        if not poly.isSelected()
          poly.google_poly.setOptions @selected_style
          poly.select()
          @selected_polygons.add(poly)

    google.maps.event.clearInstanceListeners @selMarker
    google.maps.event.removeListener @lstnr
    @selMarker.setMap null
    
  clearSel: ->
    @selected_polygons.each (poly) =>
      poly.google_poly.setOptions @unselected_style
      poly.unSelect()

    @selected_polygons.reset()

  refreshList: ->
    $('#selected-regions').find('li').not('.nav-header').remove();
    @selected_polygons.each (poly) =>
      $('#selected-regions').append("<li class='region'>"+poly.area.get('name')+"</li>")

    @renderMapButtons()

  renderMapButtons: ->
    btnDom = $('#map-buttons')
    if @selected_polygons.length > 0
      btnDom.removeClass('hide').addClass('show') if btnDom.hasClass('hide')
    else
      btnDom.removeClass('show').addClass('hide') if btnDom.hasClass('show')

  selectArea: (poly) ->
    if poly.isSelected()
      poly.google_poly.setOptions @unselected_style
      poly.unSelect()
      @selected_polygons.remove(poly)
    else
      poly.google_poly.setOptions @selected_style
      poly.select()
      @selected_polygons.add(poly)

  addAll: () ->
    @options.regions.each(@addOne)
    #z = new Mapbadger.Collections.ZipcodesCollection()
    #z.fetch(
      #success: (zipcode) =>
        #for zip in zipcode
          #new google.maps.Polygon({
            #paths: eval(zipcode.get('region_to_mvc'))
            #map: @map
          #})
    #)

  createPoly: (area) ->
    ply = new Mapbadger.Models.Polygon({area: area, map: @map})
    self = this
    ply.google_poly.setOptions(@unselected_style)
    google.maps.event.addListener(ply.google_poly, 'click', -> self.selectArea(ply))
    @polygons.add(ply)
    ply

  addHidden: (area) ->
    ply = @createPoly(area)
    ply.google_poly.setVisible false

  addOne: (region) -> 
    @createPoly(region)

    unless region.zipcodes.isEmpty()
      @zip_states.add(region)
      region.zipcodes.each @addHidden

  addHeat: ->
    oppsData = @options.opportunities.map( (opp) ->
      {
        lat: opp.get('lat'),
        lng: opp.get('lng'),
        counts: 1
      }
    )
    heatData = {
      max: 40,
      data: oppsData
    }
    google.maps.event.addListenerOnce(@map, 'idle', => @heatmap.setDataSet(heatData))

  removeHeat: ->
    @heatmap.toggle()

  # addOpportunity: (opportunity) ->
  #   latlng = new google.maps.LatLng(opportunity.get("lat"), opportunity.get("lng"))
  #   new google.maps.Marker({
  #     position: latlng
  #     map: @map
  #   })
    # @geoCoder.geocode { 'address': opportunity.address() }, (results, status) =>
    #   if (status == google.maps.GeocoderStatus.OK)
    #     @map.setCenter(results[0].geometry.location)
    #     marker = new google.maps.Marker({
    #       map: @map,
    #       position: results[0].geometry.location})
    #   else
    #     alert("Geocode was not successful for the following reason: " + status)
