newPosition = (e) ->
  $("p#a").text e.point.lng + "," + e.point.lat
  _all_overlays = @getOverlays()
  _old_point = $("div#current-location").data("current-location")
  i = 0

  while i < _all_overlays.length
    @removeOverlay _all_overlays[i]  if _all_overlays[i]? and _all_overlays[i] instanceof BMap.Marker and _old_point? and _all_overlays[i].getPosition().equals(new BMap.Point(_old_point.lng, _old_point.lat))
    i++
  if _old_point? and _old_point.name?
    showLocation this,
      lng: e.point.lng
      lat: e.point.lat
      name: _old_point.name

    $("div#current-location").data "current-location",
      lng: e.point.lng
      lat: e.point.lat
      name: _old_point.name

  else
    showLocation this,
      lng: e.point.lng
      lat: e.point.lat

    $("div#current-location").data "current-location",
      lng: e.point.lng
      lat: e.point.lat

  $("input#location_lng").val e.point.lng
  $("input#location_lat").val e.point.lat
showLocation = (map, location) ->
  return  unless location?
  marker = new BMap.Marker(new BMap.Point(location.lng, location.lat))
  label = undefined
  if location.name?
    label = new BMap.Label(location.name)
    label.setOffset new BMap.Size(15, -20)
    label.setStyle
      position: "relative"
      border: "1px solid"
      padding: "2px"
      fontSize: "11px"
      color: "white"
      backgroundColor: "#C0605F"

    marker.setLabel label
  marker.addEventListener "mouseover", (e) ->
    e.target.setTop true

  marker.addEventListener "mouseout", (e) ->
    e.target.setTop false

  map.addOverlay marker
showLocationList = (map) ->
  locations = $("div#location-list").data("location-list")
  if locations?
    i = 0

    while i < locations.length
      showLocation map, locations[i]
      i++
$ ->
  map = new BMap.Map("map-container") # 创建地图实例
  point = new BMap.Point(116.404, 39.915) # 创建点坐标
  map.centerAndZoom point, 15 # 初始化地图，设置中心点坐标和地图级别
  map.addEventListener "click", newPosition
  showLocationList map
  showLocation map, $("div#current-location").data("current-location")
