require "spec_helper"

describe Permissions::MemberPermission do
	let(:user_as_member) 			{FactoryGirl.create(:user_as_member)}
	let(:member)		 			{FactoryGirl.create(:user_as_member,tenant: user_as_member.tenant)}
	let(:other_tenant_member)		{FactoryGirl.create(:user_as_member)}

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
end