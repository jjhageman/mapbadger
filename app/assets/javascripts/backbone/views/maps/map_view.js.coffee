class Mapbadger.Views.MapView extends Backbone.View
  id: 'map-container'

  initialize: () ->
    _.bindAll(this, 'addOne', 'addAll', 'render', 'addHeat')
    @zoom = 4
    @mapTypeId = google.maps.MapTypeId.ROADMAP
    @minZoom = 3
    
    @opts =
      zoom: @zoom
      mapTypeId: @mapTypeId
      center: @mapCenter
      minZoom: @minZoom

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

    @palette = ['#AA00A2','#0A64A4','#FF9700','#7F207B','#24577B','#BF8530','#6E0069','#03406A','#A66200','#D435CD','#3E94D1','#FFB140','#D460CF','#65A5D1','#FFC673','#808000','#00FF00','#008000']
    @palette_pointer = 0

    @geoCoder = new google.maps.Geocoder()
    
  render: ->
    $(@el).html(JST["backbone/templates/maps/map"]())
    $(".sidebar").append(JST["backbone/templates/maps/map_buttons"]())
    $(".sidebar #select-regions").bind("click", @selectRegions)
    $(".sidebar #reset-map").bind("click", @clearSel)
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
    @addHeat()
    return

  clearTerritories: ->
    @selected_polygons.reset()
    @polygons.each (ply) =>
      ply.google_poly.setOptions(@unselected_style)
      ply.unSelect()

  displayTerritoryEdit: (territory) ->
    territory.regions.each (reg) =>
      region_id = reg.id || reg.get("region_id")
      poly = @polygons.get(region_id)
      poly.select()
      @selected_polygons.add(poly)
      poly.google_poly.setOptions({
        fillColor: '#777777'
        fillOpacity: 0.75
        clickable: true
      })

  displayTerritory: (territory) ->
    color = @nextColor()
    territory.regions.each (reg) =>
      region_id = reg.id || reg.get("region_id")
      poly = @polygons.get(region_id)
      poly.select()
      poly.google_poly.setOptions({
        fillColor: color
        fillOpacity: 0.75
        clickable: false
      })

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
    $('#selected-states').empty()
    @selected_polygons.each (poly) =>
      $('#selected-states').append("<li>"+poly.name+"</li>")

  addState: (poly) ->
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
    z = new Mapbadger.Collections.ZipcodesCollection()
    z.fetch(
      success: (zcta) =>
        for zip in zcta
          new google.maps.Polygon({
            paths: eval(zcta.get('region_to_mvc'))
            map: @map
          })
    )
    #google.maps.event.addListener @map, 'bounds_changed', (event) =>
    #  @getZips(@map.getBounds())
    # @options.opportunities.each(@addOpportunity)
  
  addOne: (region) ->
    ply = new Mapbadger.Models.Polygon({region: region, map: @map})
    self = this
    google.maps.event.addListener(ply.google_poly, 'click', -> self.addState(ply))
    ply.google_poly.setOptions(@unselected_style)
    @polygons.add(ply)

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
