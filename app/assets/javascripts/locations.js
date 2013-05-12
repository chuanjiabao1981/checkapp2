var getLocationIssueInfoWindow, lushu, newPosition, showLocation, showLocationList, trackPoint;

getLocationIssueInfoWindow = void 0;

newPosition = void 0;

showLocation = void 0;

showLocationList = void 0;

newPosition = void 0;

showLocation = void 0;

showLocationList = void 0;

lushu = void 0;

newPosition = function(e) {
  var i, s, _all_overlays, _old_point;
  i = void 0;
  _all_overlays = void 0;
  _old_point = void 0;
  i = void 0;
  _all_overlays = void 0;
  _old_point = void 0;
  _all_overlays = this.getOverlays();
  _old_point = $("div#map-config").data("current-location");
  i = 0;
  while (i < _all_overlays.length) {
    if ((_all_overlays[i] != null) && _all_overlays[i] instanceof BMap.Marker && (_old_point != null) && _all_overlays[i].getPosition().equals(new BMap.Point(_old_point.lng, _old_point.lat))) {
      this.removeOverlay(_all_overlays[i]);
    }
    i++;
  }
  if ((_old_point != null) && (_old_point.name != null)) {
    showLocation(this, {
      lng: e.point.lng,
      lat: e.point.lat,
      name: _old_point.name
    });
    $("div#map-config").data("current-location", {
      lng: e.point.lng,
      lat: e.point.lat,
      name: _old_point.name
    });
  } else {
    showLocation(this, {
      lng: e.point.lng,
      lat: e.point.lat
    });
    $("div#map-config").data("current-location", {
      lng: e.point.lng,
      lat: e.point.lat
    });
  }
  $($("div#map-config").data("input")["lng"]).val(e.point.lng);
  $($("div#map-config").data("input")["lat"]).val(e.point.lat);
  s = $("div#map-config").data("input")["zoom"];
  if (s != null) {
    return $(s).val(this.getZoom());
  }
};

addTrackPoint = function(e)
{
  showLocation(this, {
      lng: e.point.lng,
      lat: e.point.lat
    });
  $.ajax({
          type: "POST",
          url: '/api/v1/track_points',
          data:   JSON.stringify({
                                "track_points" : [
                                                    {
                                                        "generated_time_of_client_version": 1367313501,
                                                        "radius": 10,
                                                        "lng": e.point.lng,
                                                        "lat": e.point.lat,
                                                        "interval_time_between_generate_and_submit": 0,
                                                        "coortype": "browser"
                                                    }
                                                  ]
                                }
                              ),
          contentType: "application/json; charset=utf-8",
          dataType: "json"
        }
  )
}

getLocationIssueInfoWindow = function(location) {
  var infoWindow;
  infoWindow = void 0;
  if (location == null) {
    return null;
  }
  if (location.issue_info != null) {
    infoWindow = new BMap.InfoWindow(location.issue_info, {
      title: "<div style='border-bottom:2px dotted'>" + location.name + "</div>",
      height: 0,
      width: 0
    });
    return infoWindow;
  }
  return null;
};

showLocation = function(map, location) {
  var label, marker;
  label = void 0;
  marker = void 0;
  label = void 0;
  marker = void 0;
  if (location == null) {
    return;
  }
  marker = new BMap.Marker(new BMap.Point(location.lng, location.lat));
  marker.location_info = getLocationIssueInfoWindow(location);
  label = void 0;
  if ((location.name != null) && location.name !== "") {
    label = new BMap.Label(location.name);
    label.setOffset(new BMap.Size(15, -20));
    label.setStyle({
      position: "relative",
      border: "1px solid",
      padding: "2px",
      fontSize: "11px",
      color: "white",
      backgroundColor: "#C0605F"
    });
    label.enableMassClear();
    marker.setLabel(label);
  }
  marker.addEventListener("mouseover", function(e) {
    return e.target.setTop(true);
  });
  marker.addEventListener("mouseout", function(e) {
    return e.target.setTop(false);
  });
  marker.addEventListener("click", function(e) {
    if (e.target.location_info != null) {
      return e.target.openInfoWindow(e.target.location_info);
    }
  });
  return map.addOverlay(marker);
};

showLocationList = function(map) {
  var i, locations, _results;
  i = void 0;
  locations = void 0;
  _results = void 0;
  i = void 0;
  locations = void 0;
  _results = void 0;
  locations = $("div#location-list").data("location-list");
  if (locations != null) {
    i = 0;
    _results = [];
    while (i < locations.length) {
      showLocation(map, locations[i]);
      _results.push(i++);
    }
    return _results;
  }
};

trackPoint = function(map) {
  var arrPois, endIcon, endMarker, i, points, startIcon, startMarker;
  arrPois = void 0;
  i = void 0;
  lushu = void 0;
  points = void 0;
  points = $("div#map-config").data("track-points");
  arrPois = new Array();
  if (points.length > 0) {
    i = 0;
    while (i < points.length) {
      arrPois[i] = new BMap.Point(points[i].lng, points[i].lat);
      i++;
    }
    map.addOverlay(new BMap.Polyline(arrPois, {
      strokeColor: "#111"
    }));
    startIcon = new BMap.Icon("/img/start.png", new BMap.Size(30, 30));
    endIcon = new BMap.Icon("/img/end.png", new BMap.Size(30, 30));
    startMarker = new BMap.Marker(arrPois[0]);
    endMarker = new BMap.Marker(arrPois[points.length - 1]);
    startMarker.setIcon(startIcon);
    endMarker.setIcon(endIcon);
    map.addOverlay(startMarker);
    map.addOverlay(endMarker);
    map.setViewport(arrPois);
    lushu = new BMapLib.LuShu(map, arrPois, {
      defaultContent: $("div#map-config").data("track-user-name").name,
      speed: 4000,
      landmarkPois: []
    });
    $("button#run").click(function() {
      return lushu.start();
    });
    $("button#stop").click(function() {
      return lushu.stop();
    });
    $("button#pause").click(function() {
      return lushu.pause();
    });
    $("button#hide").click(function() {
      return lushu.hideInfoWindow();
    });
    return $("button#show").click(function() {
      return lushu.showInfoWindow();
    });
  }
};

$(function() {
  var map, point;
  map = void 0;
  point = void 0;
  map = void 0;
  point = void 0;
  if ($("#map-container")[0]) {
    map = new BMap.Map("map-container");
    point = new BMap.Point($("div#map-config").data("center-lng"), $("div#map-config").data("center-lat"));
    map.addControl(new BMap.NavigationControl());
    map.addControl(new BMap.ScaleControl());
    map.addControl(new BMap.OverviewMapControl());
    map.addControl(new BMap.MapTypeControl());
    map.centerAndZoom(point, $("div#map-config").data("zoom"));
    if ($("div#map-config").data("show-click-position")) {
      map.addEventListener("click", newPosition);
    }
    if ($("div#map-config").data("add-track-point")){
      map.addEventListener("click", addTrackPoint);
    }
    showLocationList(map);
    showLocation(map, $("div#map-config").data("current-location"));
    return trackPoint(map);
  }
});
