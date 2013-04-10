require "spec_helper"

describe Permissions::SuperAdminPermission do
	subject {Permissions.permission_for(FactoryGirl.build(:user_as_super_admin))}
	it "allow anything" do
		should allow(:any,:thing)
		should allow_param(:any,:thing)
	end	
end