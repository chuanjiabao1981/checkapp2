namespace :role do 
	task :init => :environment do
		Role.where(:name => Role::SuperAdmin).first_or_create!(:level => Role::SuperAdminLevel)
		Role.where(:name => Role::Admin).first_or_create!(:level => Role::AdminLevel)
		Role.where(:name => Role::Member).first_or_create!(:level => Role::MemberLevel)
	end
end