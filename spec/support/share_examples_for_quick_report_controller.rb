#encoding: utf-8

shared_examples "quick_report index" do
	it "should have cotent" do
		own_quick_reports.each do |o|
			page.should 		have_link o.issue.desc,href: quick_report_path(o)
			page.should 		have_link I18n.t('views.text.edit'),href: edit_quick_report_path(o)
			page.should 		have_content o.issue.human_state_name
			page.should 		have_content o.issue.level
		end
		other_quick_reports.each do |o|
			page.should 		have_link o.issue.desc,href: quick_report_path(o)
			page.should 		have_content o.issue.human_state_name
			page.should 		have_content o.issue.level
		end
	end
end
shared_examples "quick_report new and create" do
	before  do
		signin(user)
		visit(new_quick_report_path)
		fill_in I18n.t("activerecord.attributes.issue.desc"),with: "test test test"
		select  '高',from: I18n.t("activerecord.attributes.issue.level")
		select  other_user_as_member.name ,from: I18n.t("activerecord.attributes.issue.responsible_person_id")
		click_button I18n.t("helpers.submit.create",model: I18n.t("activerecord.models.quick_report"))
	end
	it "should have content" do
		should have_content "test test test"
	end
end
shared_examples "quick_report edit and update" do
	before do 
		signin(user)
		visit(quick_reports_path)
		find("a[href=\"#{edit_quick_report_path(own_quick_reports[0])}\"]").click
		select Issue.human_state_event_name(:close) , from: I18n.t("activerecord.attributes.issue.state_event")
		click_button I18n.t("helpers.submit.update",model: I18n.t("activerecord.models.quick_report"))
	end
	it "should have content" do
		should have_content Issue.human_state_name(:closed)
	end
end