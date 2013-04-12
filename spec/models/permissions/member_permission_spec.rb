require "spec_helper"

describe Permissions::MemberPermission do
	let(:user_as_member) 			{FactoryGirl.create(:user_as_member)}
	let(:member)		 			{FactoryGirl.create(:user_as_member,tenant: user_as_member.tenant)}
	let(:issue_of_the_member)		{FactoryGirl.create(:issue,tenant: user_as_member.tenant,finder: user_as_member)}
	let(:issue_of_the_member_responsible) {FactoryGirl.create(:issue,tenant: user_as_member.tenant,responsible_person: user_as_member)}
	let(:other_tenant_issue)		{FactoryGirl.create(:issue)}
	let(:other_user_issue)			{FactoryGirl.create(:issue,tenant: user_as_member.tenant,finder: member)}
	let(:other_tenant_member)		{FactoryGirl.create(:user_as_member)}
	let(:resolve)					{FactoryGirl.create(:resolve_with_responsible_person,tenant: user_as_member.tenant,submitter: user_as_member)}
	let(:other_resolve) 			{FactoryGirl.create(:resolve_with_responsible_person,tenant: member.tenant,submitter: member)}



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
	it "allows issue" do
		should allow(:issues,:new)
		should allow(:issues,:create)
		should allow(:issues,:index)
		should allow(:issues,:edit,issue_of_the_member)
		should allow(:issues,:update,issue_of_the_member)
		should allow(:issues,:destroy,issue_of_the_member)
		should_not allow(:issues,:edit,other_tenant_issue)
		should_not allow(:issues,:update,other_tenant_issue)
		should_not allow(:issues,:destroy,other_tenant_issue)
		should_not allow(:issues,:edit,other_user_issue)
		should_not allow(:issues,:update,other_user_issue)
		should_not allow(:issues,:destroy,other_user_issue)
		should_not allow_param(:issue,:tenant_id)
		should_not allow_param(:issue,:finder_id)
		should_not allow_param(:issue,:issuable_id)
		should_not allow_param(:issue,:issuable_type)
		should_not allow_param(:issue,:state)
		should allow_param(:issue,:level)
		should allow_param(:issue,:desc)
		should allow_param(:issue,:reject_reason)
		should allow_param(:issue,:deadline)
		should allow_param(:issue,:responsible_person_id)
		should allow_param(:issue,:state_event)
	end
	it "allows resolves"  do
		should 		allow(:resolves,:new,issue_of_the_member_responsible)
		should_not	allow(:resolves,:new,other_user_issue)
		should 		allow(:resolves,:create,issue_of_the_member_responsible)
		should_not 	allow(:resolves,:create,other_user_issue)
		should 		allow(:resolves,:edit,resolve)
		should_not 	allow(:resolves,:edit,other_resolve)
		should 		allow(:resolves,:update,resolve)
		should_not  allow(:resolves,:update,other_resolve)

		should_not allow_param(:resolve,:submitter_id)
		should_not allow_param(:resolve,:issue_id)
		should_not allow_param(:resolve,:tenant_id)
		should 	   allow_param(:resolve,:desc)

	end

end