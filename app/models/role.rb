class Role < ActiveRecord::Base
	SuperAdmin 			= "super_admin"
	SuperAdminLevel		= 1000
	Admin 				= "admin"
	AdminLevel 			= 800
	Member				= "member"
	MemberLevel			= 600
	validates :name,  :length => {:maximum => 50},:presence => true,:uniqueness => true
	validates :level, :numericality => { :only_integer => true }
	has_many :users

	def self.get_member
		Role.where(:name => Role::Member).first_or_create!(:level => Role::MemberLevel)
	end
	def self.get_admin
		Role.where(:name => Role::Admin).first_or_create!(:level => Role::AdminLevel)
	end
	def self.get_super_admin
		Role.where(:name => Role::SuperAdmin).first_or_create!(:level => Role::SuperAdmin)
	end
end
