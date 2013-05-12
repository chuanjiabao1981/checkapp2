$(function(){
	$('#template_check_record_state').change(function(event){
		$("div.deactive_template_check_record fieldset").prependTo($("div.actvie_template_check_record"))
		$("div.actvie_template_check_record fieldset:last").prependTo($("div.deactive_template_check_record"))
	})
})


$(function(){
	$('#template_check_record_issue_attributes_organization_id').getPersonOnChange('#template_check_record_issue_attributes_responsible_person_id');
})

$(function(){
	$('#template_check_record_issue_attributes_deadline').datepicker()
})