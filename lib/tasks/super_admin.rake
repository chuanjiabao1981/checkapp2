namespace :super_admin do 
	task :init => :environment do
		a = User.new
		a.name 			= "super_admin"
		a.account 		= "super_admin"
		a.password 		= "8"
		a.password_confirmation = "8"
		a.role_id 	 = Role.where(:name => Role::SuperAdmin)[0].id
		a.save!
	end
end