require 'spec_helper'

describe User do 
	before do 
		@role_admin			= Role.find_by_name(Role::Admin) 		|| FactoryGirl.create(:admin)
		@role_super_admin	= Role.find_by_name(Role::SuperAdmin)	|| FactoryGirl.create(:super_admin)
		@a_tenant 			= FactoryGirl.create(:tenant)
	end
	describe "SuperAdmin User"  do 
		it "can have no tenat" do
			@user = FactoryGirl.build(:user_as_super_admin_without_tenant)
			@user.should be_valid

		end
		it "can't have tanant" do
			@user = FactoryGirl.build(:user_as_super_admin_with_tenant)
			@user.should_not be_valid
		end
	end
	describe "Admin User" do
		before do 
			@user_admin 		= FactoryGirl.create(:user_as_admin)
			@user_manager		= FactoryGirl.create(:user_as_member,tenant: @user_admin.tenant)
		end
		describe "add user" do
			before do 
				@new_user		= User.new_user(@user_admin,
												{:account  => "testme",
						   						:password => "123456",
						   						:password_confirmation => "123456",
						   						:name	  => "abc",
						   						:manager  => @user_manager,
						   						:tenant_id   => @a_tenant.id,
						   						:role     => @role_admin})
			end
			it "can only build member user" do
				#@new_user.valid?
				#pp @new_user.errors
				#pp @user_manager
				@new_user.should be_valid						   
				@new_user.tenant.name.should_not == @a_tenant.name ##租户不可被修改
				@new_user.should be_member
				@new_user.tenant.should == @user_admin.tenant
			end
		end
	end
	describe "Member User" do
		before do 
			@user_member 			= FactoryGirl.create(:user_as_member)
		end
		describe "add user" do
		end

	end
end