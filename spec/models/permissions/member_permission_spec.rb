require "spec_helper"

describe Permissions::MemberPermission  do
	let(:user_as_member) 			{FactoryGirl.create(:user_as_member)}
	let(:member)		 			{FactoryGirl.create(:user_as_member,tenant: user_as_member.tenant)}
	let(:issue_of_the_member)		{FactoryGirl.create(:issue,tenant: user_as_member.tenant,submitter: user_as_member)}
	let(:issue_of_the_member_responsible) {FactoryGirl.create(:issue,tenant: user_as_member.tenant,responsible_person: user_as_member)}
	let(:other_tenant_issue)		{FactoryGirl.create(:issue)}
	let(:other_user_issue)			{FactoryGirl.create(:issue,tenant: user_as_member.tenant,submitter: member)}
	let(:other_tenant_member)		{FactoryGirl.create(:user_as_member)}
	let(:resolve)					{FactoryGirl.create(:resolve_with_responsible_person,tenant: user_as_member.tenant,submitter: user_as_member)}
	let(:other_resolve) 			{FactoryGirl.create(:resolve_with_responsible_person,tenant: member.tenant,submitter: member)}
	let(:quick_report_of_member) 		{ FactoryGirl.create(:quick_report_with_issue,submitter: user_as_member) }
	let(:quick_report_of_other_member)	{ FactoryGirl.create(:quick_report_with_issue,submitter: member)}
	let(:quick_report_of_other_tenant)	{ FactoryGirl.create(:quick_report_with_issue)}




	subject				{Permissions.permission_for(user_as_member)}
	it "allows users" do
		should 		allow(:users,:index)
		should_not 	allow(:users,:new)
		should_not 	allow(:users,:create)
		should_not 	allow(:users,:destroy)
		should_not 	allow(:users,:edit,member)
		should_not  allow(:users,:destroy,member)
		should_not  allow(:users,:edit,other_tenant_member)
		should_not  allow(:users,:destroy,other_tenant_member)
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
	#it "allows issue" do
	#	should allow(:issues,:new)
	#	should allow(:issues,:create)
	#	should allow(:issues,:index)
	#	should allow(:issues,:edit,issue_of_the_member)
	#	should allow(:issues,:update,issue_of_the_member)
	#	should allow(:issues,:destroy,issue_of_the_member)
	#	should_not allow(:issues,:edit,other_tenant_issue)
	#	should_not allow(:issues,:update,other_tenant_issue)
	#	should_not allow(:issues,:destroy,other_tenant_issue)
	#	should_not allow(:issues,:edit,other_user_issue)
	#	should_not allow(:issues,:update,other_user_issue)
	#	should_not allow(:issues,:destroy,other_user_issue)
	#	should_not allow_param(:issue,:tenant_id)
	#	should_not allow_param(:issue,:submitter_id)
	#	should_not allow_param(:issue,:issuable_id)
	#	should_not allow_param(:issue,:issuable_type)
	#	should_not allow_param(:issue,:state)
	#	should allow_param(:issue,:level)
	#	should allow_param(:issue,:desc)
	#	should allow_param(:issue,:reject_reason)
	#	should allow_param(:issue,:deadline)
	#	should allow_param(:issue,:responsible_person_id)
	#	should allow_param(:issue,:state_event)
	#end
	describe "resovles" do
		it_behaves_like 'resovles permission' do
			let(:responsible_issue) {issue_of_the_member_responsible}
			let(:own_resolve)		{resolve}
			let(:not_responsible_issue)		{other_user_issue}
		end
		it "allows resolves"  do
			should_not 	allow(:resolves,:edit,other_resolve)
			should_not  allow(:resolves,:update,other_resolve)
		end
		describe "close issue resovle"  do
			let(:quick_report) {FactoryGirl.create(:quick_report_with_issue_and_resolve,
											 issue_submitter:user_as_member,
											 responsible_person: user_as_member)}
			before do
				quick_report.issue.close
			end
			it "not allow resolve" do
				should_not allow(:resolves,:edit,quick_report.issue.resolve)
			end
		end
	end
	
	describe "quick_report" do
		it_behaves_like 'quick_report permission' do
			let(:own_quick_report) {quick_report_of_member}
			let(:other_tenant_quick_report) {quick_report_of_other_tenant}
			let(:other_quick_report) {quick_report_of_other_member}
		end
		it "allow report" do
			should_not 		allow(:quick_reports,:destroy)
			should_not 		allow(:quick_reports,:edit,quick_report_of_other_member)
			should_not 		allow(:quick_reports,:update,quick_report_of_other_member)
			should_not 		allow(:quick_reports,:destroy,quick_report_of_other_member)
		end
	end

end
