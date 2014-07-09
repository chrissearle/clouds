class Map
  constructor: (element, lat, lng) ->
    lat = 0 unless lat != undefined
    lng = 0 unless lng != undefined
    @point =  new google.maps.LatLng lat, lng

    @options =
      zoom: 8
      maxZoom: 15
      center: @point
      mapTypeId: google.maps.MapTypeId.ROADMAP

    @map = new google.maps.Map element, @options

  populate: (points) ->
    $.get points, (data) =>
      pointList = []
      for point in data
        latlng = new google.maps.LatLng point['latitude'], point['longitude']
        pointList.push latlng
        @.addPoint(latlng, point['name'])
      @.zoomToFit pointList

  addPoint: (latlng, name, link) ->
    marker = new google.maps.Marker
      position: latlng
      map: @map
      title: name

    if link != undefined
      google.maps.event.addListener marker, 'click', ->
        window.location = link

    marker

  zoomToFit: (latlngs) ->
    bounds = new google.maps.LatLngBounds()

    bounds.extend latlng for latlng in latlngs

    @map.fitBounds bounds

  zoomToFitCenter: ->
    @.zoomToFit [@point]


readyCallback = ->
  map = new Map($('#map').get(0), 60, 10)
  map.populate($('#map').data('points'))

$(document).ready(readyCallback)
$(document).on('page:load', readyCallback)