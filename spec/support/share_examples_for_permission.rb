shared_examples "quick_report permission" do
	it "allows actions" do
		should 		allow(:quick_reports,:new)
		should 		allow(:quick_reports,:index)
		should 		allow(:quick_reports,:create)
		should 		allow(:quick_reports,:edit,own_quick_report)
		should 		allow(:quick_reports,:update,own_quick_report)
		should_not 	allow(:quick_reports,:edit,other_tenant_quick_report)
		should_not 	allow(:quick_reports,:update,other_tenant_quick_report)
		should_not 	allow(:quick_reports,other_tenant_quick_report)
	end
	it "allows params" do
		should_not  allow_param(:quick_report,:tenant)
	end
	it "allows nested params" do
		should 		allow_nested_param(:quick_report,:issue_attributes,:level)
		should 		allow_nested_param(:quick_report,:issue_attributes,:desc)
		should 		allow_nested_param(:quick_report,:issue_attributes,:reject_reason)
		should 		allow_nested_param(:quick_report,:issue_attributes,:deadline)
		should 		allow_nested_param(:quick_report,:issue_attributes,:responsible_person_id)
		should 		allow_nested_param(:quick_report,:issue_attributes,:state_event)
		should_not 	allow_nested_param(:quick_report,:issue_attributes,:tenant_id)
		should_not 	allow_nested_param(:quick_report,:issue_attributes,:submitter_id)
		should_not  allow_nested_param(:quick_report,:issue_attributes,:issuable_id)
		should_not  allow_nested_param(:quick_report,:issue_attributes,:issuable_tpye)
		should_not  allow_nested_param(:quick_report,:issue_attributes,:state)
	end
end