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
		#save_and_open_page
		click_button I18n.t("helpers.submit.update",model: I18n.t("activerecord.models.quick_report"))
	end
	it "should have content" do
		should have_content Issue.human_state_name(:closed)
	end
end

shared_examples "quick_report show" do
	it "quick_report" do
		should have_content a_quick_report.issue.desc
		should have_content a_quick_report.issue.level
		should have_content a_quick_report.issue.deadline
		should have_content a_quick_report.issue.responsible_person.name
		should have_content a_quick_report.issue.submitter.name

		should have_content a_quick_report.issue.resolve.desc if not a_quick_report.issue.resolve.nil?
	end
end

shared_examples "quick_report destroy" do
	it "destroy link" do
		page.should_not	have_link I18n.t('views.text.destroy')	if user.member?	
		page.should     have_link I18n.t('views.text.destroy'),href:quick_report_path(the_destroy_report)  if user.admin?
	end
end

shared_examples "submitter quick_report show" do
	before do
		signin(owner)
		visit(quick_reports_path)
		click_link own_quick_report.issue.desc
	end
	it_behaves_like "quick_report show" do
		let(:a_quick_report) {own_quick_report}
	end
	it "should have link " do
		should 		have_link I18n.t('views.text.edit'),href: edit_quick_report_path(own_quick_report)
		should_not 	have_link I18n.t('views.text.handle'),href: new_issue_resolf_path(own_quick_report.issue)
		should_not  have_link I18n.t('views.text.edit'),href: edit_resolf_path(own_quick_report.issue.resolve) if not own_quick_report.issue.resolve.nil?
	end
	it_behaves_like "quick_report destroy" do
		let(:user) {owner}
		let(:the_destroy_report) {own_quick_report}
	end
end

shared_examples "resolver quick_report show" do
	before do
		signin(resolver)
		visit(quick_reports_path)
		click_link own_quick_report.issue.desc
	end
	it_behaves_like "quick_report show" do
		let(:a_quick_report) {own_quick_report}
	end
	it "should have link " do
		should_not 		have_link I18n.t('views.text.edit'),	href: edit_quick_report_path(own_quick_report)
		should 			have_link I18n.t('views.text.handle'),	href: new_issue_resolf_path(own_quick_report.issue) if own_quick_report.issue.resolve.nil?
		should_not 		have_link I18n.t('views.text.handle'),	href: new_issue_resolf_path(own_quick_report.issue) if not own_quick_report.issue.resolve.nil?
		should  		have_link I18n.t('views.text.edit'),	href: edit_resolf_path(own_quick_report.issue.resolve) if not own_quick_report.issue.resolve.nil?
		#page.all('a').each do |a|
		#	pp a[:href]
		#end
	end
	it_behaves_like "quick_report destroy" do
		let(:user) {resolver}
		let(:the_destroy_report) {own_quick_report}

	end
end

shared_examples "other quick_report show" do
	before do
		signin(other)
		visit(quick_reports_path)
		click_link own_quick_report.issue.desc
	end
	it_behaves_like "quick_report show" do
		let(:a_quick_report) {own_quick_report}
	end
	it "should have link " do
		should_not 	have_link I18n.t('views.text.edit'),href: edit_quick_report_path(quick_report)
		should_not 	have_link I18n.t('views.text.handle'),href: new_issue_resolf_path(quick_report.issue)
		should_not  have_link I18n.t('views.text.edit'),href: edit_resolf_path(own_quick_report.issue.resolve) if not own_quick_report.issue.resolve.nil?
	end
	it_behaves_like "quick_report destroy" do
		let(:user) {other}
		let(:the_destroy_report) {own_quick_report}
	end
end
