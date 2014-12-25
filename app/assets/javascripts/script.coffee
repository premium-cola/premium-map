#= require jquery
#= require_tree ./lib

PFLocationHash = PFCircle = PFCloudmade = null
PFCloudmadeAttrib = PFCloudmadeUrl = PFIcon = null
PFLayerGroup = PFMap = PFSearch = PFShebangData = null
PFStart = PFlatlng = null

PFUrls =
  geocoder: "/geocoder?q="
  geojson: "/geojson/"
  route: "http://maps.google.com/maps?hl=de&daddr="

jQuery.extend jQuery.browser,
  mobile: navigator.userAgent.toLowerCase().match(/iPad|iPhone|Android/i)

# format distance
jQuery.fn.extend formatDistance: ->
  number = @html()

  distance_regexp = /[0-9]*\.[0-9]*(km|m)/

  if distance_regexp.test(number)
    $.error "formatDistance(): Already formatted"

  if parseInt(number)
    if number > 1
      result = parseInt(Math.ceil(number * 10)) / 10 + "km"
    else if number > 10
      result = parseInt(Math.ceil(number)) + "km"
    else
      result = parseInt(number * 1000) + "m"

    @html result
  else
    $.error "formatDistance(): Not a float or int"

  this

$ ->
  $("input[placeholder], textarea[placeholder]").placeholder()
  $("#pf-container").removeClass "nojs"

  # Mobile CSS
  # TODO: We have content types for this (gosh)
  $("body").addClass "mobile"  if $.browser.mobile

  # PF Tab bar
  $("#pf-tab-bar .pf-tab-header a").click ->
    t = $(this)
    unless t.hasClass("pf-current")
      $(".pf-tab").hide()
      $("#pf-tab-bar a").removeClass "pf-current"
      $("#pf-" + t.attr("id").split("-")[1] + "-tab").show()
      t.addClass "pf-current"

  PFLocationHash = window.location.hash.split("#!")
  PFShebangData = []

  # we have shebang data
  if PFLocationHash.length > 1
    PFShebangData = PFLocationHash[1].split("/")

  # search var
  PFSearch =
    where: (PFShebangData[4] or "51.165691,10.451526")
    type: (PFShebangData[2] or "d")
    product: (PFShebangData[3] or "c")
    items: []
    coord:
      lat: 0
      lng: 0

  PFlatlng = PFSearch.where.split(",")
  PFSearch.coord.lat = parseFloat(PFlatlng[0])
  PFSearch.coord.lng = parseFloat(PFlatlng[1])

  # set values of selects
  $("#pf-layer-select").val PFSearch.type + "-" + PFSearch.product

  # custom marker
  PFIcon = L.Icon.extend(
    iconUrl: "/assets/leaflet/marker-small.png"
    shadowUrl: "/assets/leaflet/marker-shadow-small.png"
    iconSize: new L.Point(19, 31)
    shadowSize: new L.Point(31, 31)
    iconAnchor: new L.Point(9, 31)
    popupAnchor: new L.Point(-8, -31)
  )

  # create map
  PFMap = new L.Map("pf-map")

  # init cloudmade
  PFCloudmadeUrl = "http://{s}.tile.osm.org/{z}/{x}/{y}.png"
  PFCloudmadeAttrib = "Map data &copy; " + new Date().getFullYear() + " OpenStreetMap,"
  PFCloudmade = new L.TileLayer PFCloudmadeUrl,
    maxZoom: 18
    attribution: PFCloudmadeAttrib

  # init map
  PFStart = new L.LatLng(PFSearch.coord.lat, PFSearch.coord.lng)
  PFMap.setView(PFStart, (PFShebangData[5] or 5)).addLayer PFCloudmade

  # add red circle if highlight option
  if PFShebangData[6] is "highlight"
    PFCircle = new L.Circle PFStart, 100,
      color: "red"
      fillColor: "transparent"
      fillOpacity: 0.75

    PFMap.addLayer PFCircle

  # map layer group
  PFLayerGroup = new L.LayerGroup()
  PFMap.addLayer PFLayerGroup

  # on layer change
  $("#pf-layer-select").bind "change", ->
    Map.setFuckedUpSelection $("#pf-layer-select").val()

  # update shebang on zoom and move
  PFMap.on "zoomend", Map.updateShebang
  PFMap.on "moveend", Map.updateShebang

  $("#pf-results-load-more-link").click ->
    Phonebook.loadMore()
    $("html, body").animate \
      {scrollTop: $(window).scrollTop() + 120}, 250

  # initial update
  Map.update()

class Phonebook
  @loadMore: (n=3) ->
    for i in [0..n] when PFSearch.items.length > 0
      # add route url
      p = PFSearch.items.pop().properties
      p.routeUrl = PFUrls.route + escape(p.street) + ",+" + escape(p.city) + ",+" + escape(p.country)

      # render element
      $("#pf-results").append Mustache.render(PFListItemTemplate, p)

      # fade in element
      $("#pf-results li:last-child").fadeOut(0).fadeIn 2 * 250

      # format
      $("#pf-results li:last-child .pf-distance").formatDistance()

    # hide link if no more items
    if PFSearch.items.length == 0
      $("#pf-results-load-more-link").hide()
    else
      $("#pf-results-load-more-link").show()

class Geocoder
  @search: (d, cb) ->
    url = "#{PFUrls.geojson}/#{d.type}/#{d.product}" +
          "/near/#{d.where}"
    $.getJSON url, cb

  @locate: (what, cb) ->
    $.getJSON "#{PFUrls.geocoder}/#{what}", cb

class Map
  @setFuckedUpSelection: (fuck) ->
    # extract search parameters
    v = fuck.split '-'

    PFSearch.type = v[0]
    PFSearch.product = v[1]

    Map.update()

  @updateShebang: ->
    window.location.hash = \
        "!/#{PFSearch.type}" +
        "/#{PFSearch.product}/#{PFMap.getCenter().lat}" +
        ",#{PFMap.getCenter().lng}/#{PFMap.getZoom()}"

  @search: (what) ->
    return if what.length <= 0

    Geocoder.locate what, (data) ->
      if data.result != "ok"
        alert "Leider wurde kein Ort zu Ihrer Eingabe gefunden!"
        $("#pf-search-input").trigger "focus"
        return

      # zoom map
      search_result = new L.LatLng(data.coord.lat, data.coord.lng)
      PFMap.setView search_result, 15
      PFSearch.where = data.coord.lat + "," + data.coord.lng
      Map.update()

  @update: ->
    Map.updateShebang()

    # add loading class
    Geocoder.search PFSearch, (data) ->
      # geoJSON Layer
      PFGeoJSONLayer = new L.GeoJSON null,
        pointToLayer: (latlng) ->
          new L.Marker latlng,
            icon: new PFIcon

      # bind Popups
      PFGeoJSONLayer.on "featureparse", (e) ->
        e.layer.bindPopup Mustache.render(PFPopupTemplate, e.properties)  if e.properties
        return

      # clear old layers and add new layer
      PFLayerGroup.clearLayers()
      PFLayerGroup.addLayer PFGeoJSONLayer
      PFGeoJSONLayer.addGeoJSON data

      # update search var
      PFSearch.items = data.features.reverse()

      # if found, hide no-results div
      if data.features.length > 0
        $("#pf-no-results").hide()
      else
        $("#pf-no-results").show()

      # clear list
      $("#pf-results li").remove()

      # display first 3 list elements
      Phonebook.loadMore();

      # close all open popups
      $("a.leaflet-popup-close-button").trigger "click"

$(window).ready ->
  # TODO: Prevent multiple at the same time?
  $("#pf-search-now").bind "click", ->
    Map.search $("#pf-search-input").val()
    false

  # Reset the value of the layer dropdown
  # (browsers do cache this)
  # TODO: Encapsulate!
  $("#pf-layer-select").val("l-c")
  Map.setFuckedUpSelection "l-c"
