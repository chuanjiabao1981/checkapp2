$(function(){
	$('#quick_report_issue_attributes_organization_id').change(function(event){
		$('#quick_report_issue_attributes_responsible_person_id').load('/api/v1/organizations/users?organization_id='+$(event.target).val())
	})
})