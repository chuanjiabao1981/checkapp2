jQuery(function() {
  return $("#users").dataTable({
    bJQueryUI: false,
    bAutoWidth: false,
    sPaginationType: "full_numbers",
    sDom: "<\"table-header\"fl>t<\"table-footer\"ip>"
  });
});

$(function() {
  return $("#track_day").datepicker();
});

$(function() {
  return $("#track_start_time").timepicker({showMeridian:false});
});

$(function() {

  return $("#track_end_time").timepicker({showMeridian:false});
});

$(function(){
	$('#checkin_organization').getPersonOnChange('#checkin_user');
})
$(function() {
  return $("#checkin_start_day").datepicker();
});
$(function() {
  return $("#checkin_end_day").datepicker();
});

getSelectLocationPoint = function(location)
{
  point=$(location).val().substr(6).replace('(','').replace(')','').split(' ')
  name=$(location+" option[value=\""+$(location).val() +"\"]").text()
  return {lng:point[0],lat:point[1],name: name}
}
$(function(){
 if( $("#checkin_location")[0]){
  l = getSelectLocationPoint('#checkin_location');
  setOldLocation(l);
  showLocation(getCheckAppMap(), l);
  getCheckAppMap().panTo(new BMap.Point(l.lng,l.lat));
  }

})
$(function(){
  $('#checkin_location').change(function(e){
    l = getSelectLocationPoint('#checkin_location');
    removeLocation(getCheckAppMap(),getOldLocation());
    setOldLocation(l);
    getCheckAppMap().panTo(new BMap.Point(l.lng,l.lat));
    showLocation(getCheckAppMap(), l);
  })
})
