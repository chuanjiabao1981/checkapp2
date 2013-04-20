jQuery ->
  $("#users").dataTable 
    bJQueryUI: false
    bAutoWidth: false
    sPaginationType: "full_numbers"
    sDom: "<\"table-header\"fl>t<\"table-footer\"ip>"