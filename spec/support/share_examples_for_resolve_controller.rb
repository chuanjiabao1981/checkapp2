shared_examples "resolve new and create" do
	before do
		signin(user)
		visit(quick_reports_path) 
		click_link quick_report.issue.desc
		click_link I18n.t('views.text.handle')
		fill_in I18n.t('activerecord.attributes.resolve.desc') ,with: 'ttttttttt'
		page.should have_content Issue.human_state_name(:opened)
		click_button I18n.t("helpers.submit.create",model: I18n.t("activerecord.models.resolve"))
	end
	it "should have content" do
		should have_content 'ttttttttt'
		should have_content Issue.human_state_name(:verifying_resolve)
	end
end