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
  return $("#track_start_time").timepicker();
});

$(function() {
  return $("#track_end_time").timepicker();
});
