getLocationIssueInfoWindow = undefined
newPosition = undefined
showLocation = undefined
showLocationList = undefined
newPosition = undefined
showLocation = undefined
showLocationList = undefined
lushu = undefined

newPosition = (e) ->
  i = undefined
  _all_overlays = undefined
  _old_point = undefined
  i = undefined
  _all_overlays = undefined
  _old_point = undefined
  _all_overlays = @getOverlays()
  _old_point = $("div#map-config").data("current-location")
  i = 0
  while i < _all_overlays.length
    @removeOverlay _all_overlays[i]  if (_all_overlays[i]?) and _all_overlays[i] instanceof BMap.Marker and (_old_point?) and _all_overlays[i].getPosition().equals(new BMap.Point(_old_point.lng, _old_point.lat))
    i++
  if (_old_point?) and (_old_point.name?)
    showLocation this,
      lng: e.point.lng
      lat: e.point.lat
      name: _old_point.name

    $("div#map-config").data "current-location",
      lng: e.point.lng
      lat: e.point.lat
      name: _old_point.name

  else
    showLocation this,
      lng: e.point.lng
      lat: e.point.lat

    $("div#map-config").data "current-location",
      lng: e.point.lng
      lat: e.point.lat

  $($("div#map-config").data("input")["lng"]).val e.point.lng
  $($("div#map-config").data("input")["lat"]).val e.point.lat
  s = $("div#map-config").data("input")["zoom"]
  $(s).val @getZoom()  if s?

getLocationIssueInfoWindow = (location) ->
  infoWindow = undefined
  return null  unless location?
  if location.issue_info?
    infoWindow = new BMap.InfoWindow(location.issue_info,
      title: "<div style='border-bottom:2px dotted'>" + location.name + "</div>"
      height: 0
      width: 0
    )
    return infoWindow
  null

showLocation = (map, location) ->
  label = undefined
  marker = undefined
  label = undefined
  marker = undefined
  return  unless location?
  marker = new BMap.Marker(new BMap.Point(location.lng, location.lat))
  marker.location_info = getLocationIssueInfoWindow(location)
  label = undefined
  if location.name? and location.name isnt ""
    label = new BMap.Label(location.name)
    label.setOffset new BMap.Size(15, -20)
    label.setStyle
      position: "relative"
      border: "1px solid"
      padding: "2px"
      fontSize: "11px"
      color: "white"
      backgroundColor: "#C0605F"

    label.enableMassClear()
    marker.setLabel label
  marker.addEventListener "mouseover", (e) ->
    e.target.setTop true

  marker.addEventListener "mouseout", (e) ->
    e.target.setTop false

  marker.addEventListener "click", (e) ->
    e.target.openInfoWindow e.target.location_info  if e.target.location_info?

  map.addOverlay marker

showLocationList = (map) ->
  i = undefined
  locations = undefined
  _results = undefined
  i = undefined
  locations = undefined
  _results = undefined
  locations = $("div#location-list").data("location-list")
  if locations?
    i = 0
    _results = []
    while i < locations.length
      showLocation map, locations[i]
      _results.push i++
    _results

trackPoint = (map) ->
  arrPois = undefined
  i = undefined
  lushu = undefined
  points = undefined
  points = $("div#map-config").data("track-points")
  arrPois = new Array()
  if points.length > 0
    i = 0
    while i < points.length
      arrPois[i] = new BMap.Point(points[i].lng, points[i].lat)
      i++
    map.addOverlay new BMap.Polyline(arrPois,
      strokeColor: "#111"
    )
    startIcon = new BMap.Icon("/img/start.png", new BMap.Size(30,30))
    endIcon   = new BMap.Icon("/img/end.png"  , new BMap.Size(30,30))
    startMarker = new BMap.Marker(arrPois[0])
    endMarker   = new BMap.Marker(arrPois[points.length-1])
    startMarker.setIcon startIcon
    endMarker.setIcon endIcon
    map.addOverlay startMarker
    map.addOverlay endMarker
    map.setViewport arrPois
    lushu = new BMapLib.LuShu(map, arrPois,
      defaultContent: $("div#map-config").data("track-user-name").name
      speed: 450
      landmarkPois: []
    )
    $("button#run").click ->
      lushu.start()

    $("button#stop").click ->
      lushu.stop()

    $("button#pause").click ->
      lushu.pause()

    $("button#hide").click ->
      lushu.hideInfoWindow()

    $("button#show").click ->
      lushu.showInfoWindow()




$ ->
  map = undefined
  point = undefined
  map = undefined
  point = undefined
  if $("#map-container")[0]
    map = new BMap.Map("map-container")
    point = new BMap.Point($("div#map-config").data("center-lng"), $("div#map-config").data("center-lat"))
    map.addControl new BMap.NavigationControl()
    map.addControl new BMap.ScaleControl()
    map.addControl new BMap.OverviewMapControl()
    map.addControl new BMap.MapTypeControl()
    map.centerAndZoom point, $("div#map-config").data("zoom")
    map.addEventListener "click", newPosition  if $("div#map-config").data("show-click-postion")
    showLocationList map
    showLocation map, $("div#map-config").data("current-location")
    trackPoint map
