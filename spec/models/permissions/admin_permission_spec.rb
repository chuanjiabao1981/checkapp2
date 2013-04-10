require "spec_helper"

describe Permissions::SuperAdminPermission do
	let(:user_as_admin) {FactoryGirl.create(:user_as_admin)}
	let(:member)		{FactoryGirl.create(:user_as_member,tenant: user_as_admin.tenant)}
	let(:other_member)  {FactoryGirl.create(:user_as_member)}
	subject				{Permissions.permission_for(user_as_admin)}
	it "allows users" do
		should 		allow(:users,:new)
		should 		allow(:users,:create)
		should 		allow(:users,:destroy,member)
		should 		allow(:users,:edit,member)
		should 		allow(:users,:index)
		should      allow_param(:user,:name)
		should 		allow_param(:user,:mobile)
		should 		allow_param(:user,:account)
		should 		allow_param(:user,:password)
		should 		allow_param(:user,:password_confirmation)
		should_not  allow(:users,:edit,other_member)
		should_not  allow(:users,:destroy,other_member)
		should_not  allow_param(:user,:role)
		should_not  allow_param(:user,:tenant)
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