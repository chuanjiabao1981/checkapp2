jQuery ->
  $("#users").dataTable 
    bJQueryUI: false
    bAutoWidth: false
    sPaginationType: "full_numbers"
    sDom: "<\"table-header\"fl>t<\"table-footer\"ip>"

$ ->
  $("#track_day").datepicker()
$ ->
  $("#track_start_time").timepicker();
$ ->
  $("#track_end_time").timepicker();


	
