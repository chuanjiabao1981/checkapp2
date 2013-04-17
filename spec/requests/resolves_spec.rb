require 'spec_helper'

describe "Resolves" do
	let!(:user_as_super_admin)   {FactoryGirl.create(:user_as_super_admin)}
	let!(:user_as_admin) 		 {FactoryGirl.create(:user_as_admin)}
	let!(:user_as_member)		 {FactoryGirl.create(:user_as_member,tenant:user_as_admin.tenant)}
	let!(:other_user_as_member)	 {FactoryGirl.create(:user_as_member,tenant:user_as_admin.tenant)}
	subject{page}
	describe "new && creat" do
		describe "member"  do
			let!(:quick_report)  { FactoryGirl.create(:quick_report_with_issue,
													   submitter: user_as_member,)}
			let!(:user) 		 { quick_report.issue.responsible_person }
			before do
				signin(user)
				visit(quick_reports_path) 
				click_link quick_report.issue.desc
				click_link I18n.t('views.text.handle')
				fill_in I18n.t('activerecord.attributes.resolve.desc') ,with: 'ttttttttt'
				page.should have_content Issue.human_state_name(:opened)
				click_button I18n.t("helpers.submit.create",model: I18n.t("activerecord.models.resolve"))
			end
			it "" do
				should have_content 'ttttttttt'
				should have_content Issue.human_state_name(:verifying_resolve)
			end
		end
	end
end
