require 'spec_helper'

describe "Resolves" do
	let!(:user_as_super_admin)   {FactoryGirl.create(:user_as_super_admin)}
	let!(:user_as_admin) 		 {FactoryGirl.create(:user_as_admin)}
	let!(:user_as_member)		 {FactoryGirl.create(:user_as_member,tenant:user_as_admin.tenant)}
	let!(:other_user_as_member)	 {FactoryGirl.create(:user_as_member,tenant:user_as_admin.tenant)}
	subject{page}
	describe "new && create"do
		describe "member"  do
			it_behaves_like "resolve new and create" do
				let!(:quick_report)  { FactoryGirl.create(:quick_report_with_issue,
													   submitter: user_as_member,)}
				let!(:user) 		 { quick_report.issue.responsible_person }
			end
		end
		describe "admin" do
			it_behaves_like "resolve new and create" do
				let!(:quick_report) {FactoryGirl.create(:quick_report_with_issue,submitter: user_as_admin)}
				let!(:user) 		{quick_report.issue.responsible_person}
			end
		end
		describe "guest" do
			let!(:quick_report) {FactoryGirl.create(:quick_report_with_issue,submitter: user_as_member)}
			before do
				visit new_issue_resolf_path(quick_report.issue)
			end
			it "should no permission" do
				should have_content I18n.t('views.text.unauthorized')
			end
		end
	end
	describe "edit && update" do
		let!(:quick_report) {FactoryGirl.create(:quick_report_with_issue_and_resolve,
													issue_submitter: other_user_as_member,
													responsible_person: user_as_member)}
		let!(:user) 		{user_as_member}
		before do
			signin(user)
			visit(quick_reports_path) 
			click_link quick_report.issue.desc
			click_link I18n.t('views.text.edit')
			fill_in I18n.t('activerecord.attributes.resolve.desc') ,with: 'do it xxxx;do it xxxx.'
			page.should have_content Issue.human_state_name(:verifying_resolve)
			click_button I18n.t("helpers.submit.update",model: I18n.t("activerecord.models.resolve"))
		end
		it "have content" do
			should have_content 'do it xxxx;do it xxxx.'
		end
	end
end
