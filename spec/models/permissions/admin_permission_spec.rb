#encoding:utf-8
require "spec_helper"

describe Permissions::AdminPermission do
	let(:user_as_admin) {FactoryGirl.create(:user_as_admin)}
	let(:member)		{FactoryGirl.create(:user_as_member,tenant: user_as_admin.tenant)}
	let(:other_member)  {FactoryGirl.create(:user_as_member)}
	let(:issue)         {FactoryGirl.create(:issue,tenant: user_as_admin.tenant,responsible_person: user_as_admin)}
	let(:resolve)		{FactoryGirl.create(:resolve_with_responsible_person,tenant: user_as_admin.tenant,submitter: user_as_admin)}
	let(:other_resolve) {FactoryGirl.create(:resolve_with_responsible_person,tenant: user_as_admin.tenant,submitter: member)}
	let(:other_issue)	{FactoryGirl.create(:issue)}
	let(:quick_report_of_admin) 		{ FactoryGirl.create(:quick_report_with_issue,submitter: user_as_admin) }
	let(:quick_report_of_member) 		{ FactoryGirl.create(:quick_report_with_issue,submitter:member)}
	let(:quick_report_of_other_tenant)	{ FactoryGirl.create(:quick_report_with_issue)}
	subject				{Permissions.permission_for(user_as_admin)}
	it "allows users" do
		should 		allow(:users,:new)
		should 		allow(:users,:create)
		should 		allow(:users,:destroy,member)
		should 		allow(:users,:edit,member)
		should 	    allow(:users,:update,member)
		should 		allow(:users,:index)
		should      allow_param(:user,:name)
		should 		allow_param(:user,:mobile)
		should 		allow_param(:user,:account)
		should 		allow_param(:user,:password)
		should 		allow_param(:user,:password_confirmation)
		should_not  allow(:users,:edit,other_member)
		should_not  allow(:users,:destroy,other_member)
		should_not  allow_param(:user,:role_id)
		should_not  allow_param(:user,:tenant_id)
	end
	it "allows sessions" do
		should allow(:sessions,:new)
		should allow(:sessions,:create)
		should allow(:sessions,:destroy)
	end
	it "allows tenants" do
		should_not allow(:tenants,:new)
		should_not allow(:tenants,:create)
		should_not allow(:tenants,:edit)
		should_not allow(:tenants,:update)
		should_not allow(:tenants,:destroy)
	end
	it "allows roles" do
		should_not allow(:roles,:new)
		should_not allow(:roles,:create)
		should_not allow(:roles,:edit)
		should_not allow(:roles,:update)
		should_not allow(:roles,:destroy)
	end
	it "allows main" do
		should allow(:main,:home)
	end
	it "allows issues" do
		should allow(:issues,:new)
		should allow(:issues,:show,issue)
		should_not allow(:issues,:show,other_issue)
		should allow(:issues,:create)
		should allow(:issues,:edit,issue)
		should allow(:issues,:update,issue)
		should allow(:issues,:destroy,issue)
		should_not allow(:issues,:edit,other_issue)
		should_not allow(:issues,:update,other_issue)
		should_not allow(:issues,:destroy,other_issue)
		should_not allow_param(:issue,:tenant_id)
		should_not allow_param(:issue,:submitter_id)
		should_not allow_param(:issue,:issuable_id)
		should_not allow_param(:issue,:issuable_tpye)
		should_not allow_param(:issue,:state)
		should allow_param(:issue,:level)
		should allow_param(:issue,:desc)
		should allow_param(:issue,:reject_reason)
		should allow_param(:issue,:deadline)
		should allow_param(:issue,:responsible_person_id)
		should allow_param(:issue,:state_event)
	end

	it "allows resolves" do
		should 		allow(:resolves,:new,issue)
		should_not	allow(:resolves,:new,other_issue)
		should 		allow(:resolves,:create,issue)
		should_not 	allow(:resolves,:create,other_issue)
		should 		allow(:resolves,:edit,resolve)
		should 		allow(:resolves,:edit,other_resolve)
		should 		allow(:resolves,:update,resolve)
		should  	allow(:resolves,:update,other_resolve)
		should_not allow_param(:resolve,:submitter_id)
		should_not allow_param(:resolve,:issue_id)
		should_not allow_param(:resolve,:tenant_id)
		should 	   allow_param(:resolve,:desc)
	end
	describe "quick_report"  do
		it_behaves_like 'quick_report permission' do
			let(:own_quick_report) {quick_report_of_admin}
			let(:other_tenant_quick_report) {quick_report_of_other_tenant}
		end
		it "allow quick report" do
			should 		allow(:quick_reports,:destroy,quick_report_of_admin)
			should 		allow(:quick_reports,:edit,quick_report_of_member)
			should 		allow(:quick_reports,:update,quick_report_of_member)
			should 		allow(:quick_reports,:destroy,quick_report_of_member)
		end
	end
end
