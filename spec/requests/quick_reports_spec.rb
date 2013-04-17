#encoding: utf-8
require 'spec_helper'

describe "QuickReports" do
	let!(:user_as_super_admin)   {FactoryGirl.create(:user_as_super_admin)}
	let!(:user_as_admin) 		 {FactoryGirl.create(:user_as_admin)}
	let!(:user_as_member)		 {FactoryGirl.create(:user_as_member,tenant:user_as_admin.tenant)}
	let!(:other_user_as_member)	 {FactoryGirl.create(:user_as_member,tenant:user_as_admin.tenant)}
	subject{page}

	describe "index" do
		let!(:own_quick_reports) {
			FactoryGirl.create_list(:quick_report_with_issue_and_resolve,5,
				issue_submitter: user_as_member,
				responsible_person: other_user_as_member)
		}
		let!(:other_quick_reports){
			FactoryGirl.create_list(:quick_report_with_issue_and_resolve,5,
				issue_submitter: other_user_as_member,
				responsible_person: other_user_as_member
				)

		}
		describe "member"  do
			before do
				signin(user_as_member)
				visit(quick_reports_path)
			end
			it_behaves_like 'quick_report index'
			it "should not have the content" do
				own_quick_reports.each do |o|
					page.should_not		have_link I18n.t('views.text.destroy'),href: quick_report_path(o)
				end
				other_quick_reports.each do |o|
					page.should_not 	have_link I18n.t('views.text.edit'),href: edit_quick_report_path(o)
					page.should_not		have_link I18n.t('views.text.destroy'),href: quick_report_path(o)
				end
			end
		end
		describe "admin" do
			before do
				signin(user_as_admin)
				visit(quick_reports_path)
			end
			it_behaves_like 'quick_report index'

			it "should have the content" do
				own_quick_reports.each do |o|
					page.should		have_link I18n.t('views.text.destroy'),href: quick_report_path(o)
				end
				other_quick_reports.each do |o|
					page.should 	have_link I18n.t('views.text.edit'),href: edit_quick_report_path(o)
					page.should	have_link I18n.t('views.text.destroy'),href: quick_report_path(o)
				end
			end
		end
		describe "guest" do
			before do
				visit(quick_reports_path)
			end
			it "should no permission" do
				should have_content I18n.t('views.text.unauthorized')
			end
		end
	end
	describe "new and create" do
		describe "member"   do
			it_behaves_like "quick_report new and create" do
				let(:user) {user_as_member}
			end
		end
		describe "admin"  do
			it_behaves_like "quick_report new and create" do
				let(:user) {user_as_admin}
			end
		end
		describe "guest"  do
			before do
				visit(quick_reports_path)
			end
			it "should no permission" do
				should have_content I18n.t('views.text.unauthorized')
			end
		end
	end
	describe "edit and update" do
		let!(:own_quick_reports) {
			FactoryGirl.create_list(:quick_report_with_issue_and_resolve,5,
				issue_submitter: user_as_member,
				responsible_person: other_user_as_member)
		}
		describe "member"   do
			it_behaves_like "quick_report edit and update" do
				let(:user) {user_as_member}
 			end
		end
		describe "admin" do
			it_behaves_like "quick_report edit and update" do
				let(:user) {user_as_admin}
 			end
		end
		describe "guest" do
			before do
				visit(new_quick_report_path)
			end
			it "should no permission" do
				should have_content I18n.t('views.text.unauthorized')
			end
		end
	end
	describe "destroy" do
		let!(:own_quick_reports) {
			FactoryGirl.create_list(:quick_report_with_issue_and_resolve,5,
				issue_submitter: user_as_member,
				responsible_person: other_user_as_member)
		}
		let!(:other_quick_reports){
			FactoryGirl.create_list(:quick_report_with_issue_and_resolve,5,
				issue_submitter: other_user_as_member,
				responsible_person: other_user_as_member
				)
		}
		describe "member" do
			before do
				signin(user_as_admin)
				visit(quick_reports_path)
				@old_issue_desc = own_quick_reports[0].issue.desc
				page.should have_content @old_issue_desc
				click_link '删除'
			end
			it "should not have content" do
				should_not have_content @old_issue_desc
			end
		end
	end
	describe "show"  do
		describe "member" do
			let!(:quick_report)  { FactoryGirl.create(:quick_report_with_issue,submitter: user_as_member)}
			let!(:quick_report_with_resolve){FactoryGirl.create(:quick_report_with_issue_and_resolve,
															  issue_submitter: user_as_member,
															  responsible_person: other_user_as_member)}
			describe "quick_report submitter" do
				it_behaves_like "submitter quick_report show"  do
					let(:owner) {user_as_member}
					let(:own_quick_report) {quick_report}
				end
				it_behaves_like "submitter quick_report show" do
					let(:owner) {user_as_member}
					let(:own_quick_report) {quick_report_with_resolve}
				end
			end
			describe "resolver quick_report" do
				it_behaves_like "resolver quick_report show" do
					let(:resolver) {quick_report.issue.responsible_person}
					let(:own_quick_report) {quick_report}
				end
				it_behaves_like "resolver quick_report show" do
					let(:resolver) {quick_report_with_resolve.issue.responsible_person}
					let(:own_quick_report) {quick_report_with_resolve}
				end
			end
			describe "other person"  do
				it_behaves_like "other quick_report show" do
					let(:other) {other_user_as_member}
					let(:own_quick_report){quick_report}
				end
			end
		end
		describe "admin"  do
			let!(:quick_report)  { FactoryGirl.create(:quick_report_with_issue,submitter: user_as_admin)}
			let!(:quick_report_with_resolve){FactoryGirl.create(:quick_report_with_issue_and_resolve,
															  issue_submitter: user_as_admin,
															  responsible_person: other_user_as_member)}
			describe "quick_report submitter" do
				it_behaves_like "submitter quick_report show"  do
					let(:owner) {user_as_admin}
					let(:own_quick_report) {quick_report}
				end
			end
			describe "quick_report resolver" do
				it_behaves_like "resolver quick_report show" do
					let(:resolver) {quick_report.issue.responsible_person}
					let(:own_quick_report) {quick_report}
				end
				it_behaves_like "resolver quick_report show" do
					let(:resolver) {quick_report_with_resolve.issue.responsible_person}
					let(:own_quick_report) {quick_report_with_resolve}
				end
			end
			describe "other person"  do
				it_behaves_like "other quick_report show" do
					let(:other) {other_user_as_member}
					let(:own_quick_report){quick_report}
				end
			end
		end
	end
end
