#= require jquery
#= require_tree ./lib

PFLocationHash = PFCircle = PFCloudmade = PFCloudmadeAttrib = PFCloudmadeUrl = PFCountries = PFIcon = PFLayerGroup = PFMap = PFSearch = PFShebangData = PFStart = PFUrls = PFlatlng = null

jQuery.extend jQuery.browser,
  mobile: navigator.userAgent.toLowerCase().match(/iPad|iPhone|Android/i)

$ ->
  d = 250
  $("input[placeholder], textarea[placeholder]").placeholder()
  $("#pf-container").removeClass "nojs"

  # utf-8!
  $.ajaxSetup
    scriptCharset: "utf-8"
    contentType: "application/json; charset=utf-8"


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

    false

  # format distance
  $.fn.extend formatDistance: ->
    number = @html()

    distance_regexp = /[0-9]*\.[0-9]*(km|m)/

    if distance_regexp.test(number)
      $.error "formatDistance(): Already formatted"

    if parseInt(number) #
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

  PFLocationHash = window.location.hash.split("#!")
  PFShebangData = []

  # we have shebang data
  if PFLocationHash.length > 1
    PFShebangData = PFLocationHash[1].split("/")

  # search var
  PFSearch =
    where: (PFShebangData[4] or "51.165691,10.451526")
    country: (PFShebangData[1] or "de")
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
  $("#pf-country-select").val PFSearch.country

  # custom marker
  PFIcon = L.Icon.extend(
    iconUrl: "/assets/leaflet/marker-small.png"
    shadowUrl: "/assets/leaflet/marker-shadow-small.png"
    iconSize: new L.Point(19, 31)
    shadowSize: new L.Point(31, 31)
    iconAnchor: new L.Point(9, 31)
    popupAnchor: new L.Point(-8, -31)
  )
  PFUrls =
    geocoder: "/geocoder?q="
    geojson: "/geojson/"
    route: "http://maps.google.com/maps?hl=de&daddr="


  # countries coords
  PFCountries =
    de:
      lng: 10.451526
      lat: 51.165691

    at:
      lng: 14.550072
      lat: 47.516231

    ch:
      lng: 8.227512
      lat: 46.818188


  # create map
  PFMap = new L.Map("pf-map")

  # init cloudmade
  PFCloudmadeUrl = "http://{s}.tile.osm.org/{z}/{x}/{y}.png"
  PFCloudmadeAttrib = "Map data &copy; " + new Date().getFullYear() + " OpenStreetMap,"
  PFCloudmade = new L.TileLayer(PFCloudmadeUrl,
    maxZoom: 18
    attribution: PFCloudmadeAttrib
  )

  # init map
  PFStart = new L.LatLng(PFSearch.coord.lat, PFSearch.coord.lng)
  PFMap.setView(PFStart, (PFShebangData[5] or 5)).addLayer PFCloudmade

  # add red circle if highlight option
  if PFShebangData[6] is "highlight"
    PFCircle = new L.Circle(PFStart, 100,
      color: "red"
      fillColor: "transparent"
      fillOpacity: 0.75
    )
    PFMap.addLayer PFCircle

  # map layer group
  PFLayerGroup = new L.LayerGroup()
  PFMap.addLayer PFLayerGroup

  # on layer change
  $("#pf-layer-select").bind "change", ->

    # extract search parameters
    v = $("#pf-layer-select").val().split("-")

    # set search vars
    PFSearch.type = v[0]
    PFSearch.product = v[1]

    # update map
    $("#pf-map").trigger "update"
    return

  # on country change
  $("#pf-country-select").bind "change", ->
    Map.setCountry $("#pf-country-select").val()

  # update shebang on zoom and move
  PFMap.on "zoomend", Map.updateShebang
  PFMap.on "moveend", Map.updateShebang

  # update map
  $("#pf-map").bind "update", ->

    # update shebang hash
    Map.updateShebang()

    # add loading class
    #$('#pf-search-form .pf-loading').show();
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
      $("#pf-results").trigger "load-more"

      # close all open popups
      $("a.leaflet-popup-close-button").trigger "click"
      return

    return


  # remove loading class
  #$('#pf-search-form .pf-loading').hide();

  # load 3 more items to the pf-results list
  $("#pf-results").bind "load-more", ->

    # display 3 more items
    i = 0
    while i < 3
      if PFSearch.items.length > 0

        # add route url
        p = PFSearch.items.pop().properties
        p.routeUrl = PFUrls.route + escape(p.street) + ",+" + escape(p.city) + ",+" + escape(p.country)

        # render element
        $(this).append Mustache.render(PFListItemTemplate, p)

        # fade in element
        $("#pf-results li:last-child").fadeOut(0).fadeIn 2 * d

        # format
        $("#pf-results li:last-child .pf-distance").formatDistance()
      i++

    # hide link if no more items
    if PFSearch.items.length is 0
      $("#pf-results-load-more-link").hide()
    else
      $("#pf-results-load-more-link").show()
    return

  $("#pf-results-load-more-link").click ->
    $("#pf-results").trigger "load-more"

    #smooth scroll to bottom
    $("html, body").animate {scrollTop: $(window).scrollTop() + 120}, d
    false

  # initial update
  $("#pf-map").trigger "update"

class Geocoder
  @search: (d, cb) ->
    url = "#{PFUrls.geojson}" +
          "/#{d.country}/#{d.type}/#{d.product}" +
          "/near/#{d.where}"
    $.getJSON url, cb

  @locate: (what, cb) ->
    $.getJSON "#{PFUrls.geocoder}/#{what}", cb

class Map
  @setCountry: (c) ->
    # which country?
    switch c
      when "at"
        selected_lat = PFCountries.at.lat
        selected_lng = PFCountries.at.lng
      when "ch"
        selected_lat = PFCountries.ch.lat
        selected_lng = PFCountries.ch.lng
      else
        c = "de"
        selected_lat = PFCountries.de.lat
        selected_lng = PFCountries.de.lng

    # update search var
    PFSearch.country = c
    PFSearch.coord.lng = selected_lng
    PFSearch.coord.lat = selected_lat

    # pan+zoom country
    selected_country = new L.LatLng(selected_lat, selected_lng)
    PFMap.setView selected_country, 5

    # update
    $("#pf-map").trigger "update"

  @updateShebang: ->
    window.location.hash = \
        "!/#{PFSearch.country}/#{PFSearch.type}" +
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
      $("#pf-map").trigger "update"

$(window).ready ->
  console.log "READY!"
  # TODO: Prevent multiple at the same time?
  $("#pf-search-now").bind "click", ->
    Map.search $("#pf-search-input").val()
    false
