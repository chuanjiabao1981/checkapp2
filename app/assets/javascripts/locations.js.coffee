newPosition = (e) ->
  $("p#a").text e.point.lng + "," + e.point.lat
  _all_overlays = @getOverlays()
  _old_point = $("p#a").data("current-point")
  i = 0

  while i < _all_overlays.length
    @removeOverlay _all_overlays[i]  if _all_overlays[i]? and _all_overlays[i] instanceof BMap.Marker and _old_point? and _all_overlays[i].getPosition().equals(new BMap.Point(_old_point.lng, _old_point.lat))
    i++
  marker = new BMap.Marker(new BMap.Point(e.point.lng, e.point.lat))
  marker.setTitle "abcde"
  @addOverlay marker
  $("p#a").data "current-point",
    lng: e.point.lng
    lat: e.point.lat

  $("input#location_lng").val e.point.lng
  $("input#location_lat").val e.point.lat
showLocationList = (map) ->
  locations = $("div#location-list").data("location-list")
  if locations?
    i = 0

    while i < locations.length
      marker = new BMap.Marker(new BMap.Point(locations[i].lng, locations[i].lat))
      label = new BMap.Label(locations[i].name)
      label.setOffset new BMap.Size(40, -40)
      label.setStyle
        position: "relative"
        left: "-50%"
        top: "-8px"
        border: "1px solid blue"
        padding: "2px"
        backgroundColor: "white"

      marker.setTitle locations[i].name
      marker.setLabel label
      marker.addEventListener "mouseover", (e) ->
        e.target.setTop true

      marker.addEventListener "mouseout", (e) ->
        e.target.setTop false

      map.addOverlay marker
      i++
$ ->
  map = new BMap.Map("map-container") # 创建地图实例
  point = new BMap.Point(116.404, 39.915) # 创建点坐标
  map.centerAndZoom point, 15 # 初始化地图，设置中心点坐标和地图级别
  map.addEventListener "click", newPosition
  showLocationList map
