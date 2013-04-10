FactoryGirl.define do
	factory :role do
	end
	factory :super_admin , parent:  :role do
		name Role::SuperAdmin
		level 1000
	end
	factory :admin , parent: :role do
		name Role::Admin
		level 800
	end
	factory :member, parent: :role do
		name Role::Member
		level 600
	end
	factory :tenant do
		sequence(:name) 		{|n| "tanant_no_#{n}"}
		term					{ 5.years.since.strftime("%Y-%m-%d")}
	end
	factory :user do
		sequence(:name) 		{|n| "user_no_#{n}"}
		sequence(:account)		{|n| "account_#{n}"}
		mobile					"12345678901"
		password			    "password"
		password_confirmation	{ "#{password}"}
	end
	factory :user_as_super_admin_without_tenant , aliases: [:user_as_super_admin], parent: :user do
		role {FactoryGirl.build(:super_admin)}
	end
	factory :user_as_super_admin_with_tenant,parent: :user do
		role {FactoryGirl.build(:super_admin)}
		tenant
	end
	factory :user_as_admin , parent: :user do
		role {FactoryGirl.build(:admin)}
		tenant
	end
	factory :user_as_member, parent: :user do
		role {getRoleMember}
		tenant
		#after(:build) do |user,evaluator|
		#	m = Role.find_by_name(Role::Member) || FactoryGirl.create(:member)
		#	user.roles << m
		#end
	end
end

def getRoleMember
	Role.find_by_name(Role::Member) || FactoryGirl.create(:member)
end