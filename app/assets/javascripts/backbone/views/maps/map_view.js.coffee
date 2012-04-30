class Mapbadger.Views.MapView extends Backbone.View
  id: 'map-container'

  events:
    "click .heat-nasdaq" : "loadNasdaq"
    "click .heat-custom" : "loadCustom"
    "click .census-population" : "loadPopulation"
    "click .census-business" : "loadBusinessPopulation"
    "click .remove-heat" : "clearMap"
    "click .display-markers" : "displayMarkers"
    "click .display-heat" : "displayHeat"

  initialize: () ->
    _.bindAll(this,
      'addOne',
      'addHidden',
      'createPoly',
      'clearSel',
      'addAll',
      'render',
      'displayAreaForSaved',
      'displayAreaForEdit',
      'loadNasdaq',
      'loadCustom',
      'displayHeat',
      'displayMarkers',
      'makeMarker',
      'hideAllMarkers',
      'showHeat',
      'hideHeat',
      'clearMap')
    @zoom = 4
    @showingZips = false
    @mapTypeId = google.maps.MapTypeId.ROADMAP
    @usBnds = new google.maps.LatLngBounds(new google.maps.LatLng(23.5,-122), new google.maps.LatLng(76,-65))
    @minZoom = 3
    
    @opts =
      zoom: @zoom
      mapTypeId: @mapTypeId
      center: @mapCenter
      minZoom: @minZoom

    @mapData = 'custom'
    @dataDisplayStyle = 'heatmap'
    @markerMap =
      visible: false
      data: ''
      nasdaq: []
      custom: []

    @zip_states = new Mapbadger.Collections.RegionsCollection()
    @polygons = new Mapbadger.Collections.PolygonsCollection()
    @selected_polygons = new Mapbadger.Collections.PolygonsCollection()
    @nasdaq = new Mapbadger.Collections.OpportunitiesCollection()
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
    @legend_colors = ['#9E0142', '#D53E4F', '#F46D43', '#FDAE61', '#FEE08B', '#E6F598', '#ABDDA4', '#66C2A5', '#3288BD', '#5E4FA2']

  render: ->
    $(@el).html(JST["backbone/templates/maps/map"]())
    $(@el).prepend(JST["backbone/templates/maps/loading"]())
    @$("#map-tools").tooltip({
      selector: "button[rel=tooltip]"
    })
    return this

  nextColor: ->
    @palette_pointer = 0 if @palette_pointer >= @palette.length
    color = @palette[@palette_pointer]
    @palette_pointer++
    color

  renderMap: ->
    @map = new google.maps.Map(document.getElementById("map-canvas"), @opts)
    @map.fitBounds(@usBnds)
    @heatmap = new HeatmapOverlay(@map, {"radius":25, "visible":true, "opacity":60})
    @addAll()
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

  resetView: ->
    @map.fitBounds(@usBnds)
    $(".overlaymessage").show()

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

  territoryZoom: (territory) ->
    $(".overlaymessage").show()
    @map.fitBounds territory.bounds if territory.bounds?

  displayTerritoryEdit: (territory) ->
    territory.regions.each(@displayAreaForEdit)
    @territoryZoom territory
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

  #loadNasdaq
  #loadCustom
  #displayMarkers
  #DisplayHeat

  loadNasdaq: ->
    @mapData = 'nasdaq'
    if @nasdaq.isEmpty()
      $.ajax({
        url: 'nasdaq_companies.json',
        success: (companies) =>
          @nasdaq.reset(companies)
          @displayMapData()
      })
    else
      @displayMapData()
    
  loadCustom: (style) ->
    @mapData = 'custom'
    @displayMapData()

  displayMapData: () -> 
    if @dataDisplayStyle is 'heatmap' then @displayHeat() else @displayMarkers()

  displayHeat: ->
    @hideAllMarkers()
    @heatmap.heatmap.clear()
    opps = if @mapData is 'nasdaq' then @nasdaq else @options.opportunities
    oppsData = opps.map( (opp) ->
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
    @heatmap.setDataSet(heatData)
    @showHeat()
    @dataDisplayStyle = 'heatmap'
    @heatmap.data = @mapData
    @heatmap.visible = true
    @updateLegend()

  displayMarkers: ->
    @hideHeat()
    if @markerMap[@mapData].length > 0
      @showMarkers()
    else
      opps = if @mapData is 'nasdaq' then @nasdaq else @options.opportunities
      opps.each(@makeMarker)
    @hideMarkers()
    @dataDisplayStyle = 'markers'
    @markerMap.data = @mapData
    @markerMap.visible = true
    @updateLegend()

  makeMarker: (opp) ->
    marker = new google.maps.Marker
      position: new google.maps.LatLng(opp.get('lat'), opp.get('lng'))
      map: @map
      visible: true
    if @mapData is 'nasdaq' then @markerMap.nasdaq.push(marker) else @markerMap.custom.push(marker)

  showMarkers: ->
    for marker in @markerMap[@mapData]
      marker.setVisible true

  hideMarkers: ->
    hide_data = _.without(['nasdaq', 'custom'], @mapData)
    for marker in @markerMap[hide_data]
      marker.setVisible false

  hideAllMarkers: ->
    for data in ['nasdaq', 'custom']
      for marker in @markerMap[data]
        marker.setVisible false
    @markerMap.visible = false
    @$('#map-legend').empty()

  showHeat: ->
    unless @heatmap.heatmap.get('visible')
      @heatmap.heatmap.get('canvas').style.display = "block"
      @heatmap.heatmap.set('visible', true)
    @heatmap.visible = false

  hideHeat: ->
    if @heatmap.heatmap.get('visible')
      @heatmap.heatmap.get('canvas').style.display = "none"
      @heatmap.heatmap.set('visible', false)
    @heatmap.visible = false

  clearMap: ->
    @hideAllMarkers()
    @hideHeat()

  updateLegend: ->
    @$('#map-legend').html((JST["backbone/templates/maps/legend"](data: @mapData, display: @dataDisplayStyle)))
    @$('#legend-content').css('display', 'none').fadeIn()

  loadPopulation: ->
    @mapData = 'population'
    @clearTerritories()
    @clearMap()
    regions = @options.regions.filter( (region) ->
      region.get('population')?
    )

    max = _.max(regions, (region) ->
      region.get('population')
    ).get('population')

    min = _.min(regions, (region) ->
      region.get('population')
    ).get('population')

    inc_unit = Math.round((max-min)/10)
    scale_unit = 9/(max-min)

    for region in regions
      color = @legend_colors[Math.floor(scale_unit*(region.get('population')-min))]
      region.get('polygon').google_poly.setOptions({fillColor: color, fillOpacity: 0.75})

    @$('#map-legend').html(JST["backbone/templates/maps/legend_colors"])
    for color, i in @legend_colors
      @$('#legend-colors').append(
        '<li>'+
        @formatNumber(min+(i*inc_unit))+' - '+
        @formatNumber(min+((i+1)*inc_unit)-1)+
        '<div class="legend-box" style="background-color:'+color+';opacity:0.75"></div></li>')

  loadBusinessPopulation: ->


  formatNumber: (number) ->
    number.toString().replace /\B(?=(\d{3})+(?!\d))/g, ","

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
