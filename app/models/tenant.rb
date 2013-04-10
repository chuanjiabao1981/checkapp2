class Tenant < ActiveRecord::Base
	validates :name,:length=>{:maximum => 50},:presence => true,:uniqueness => true
	validates_date :term

	has_many :users,:dependent => :destroy

	def self.current_id=(id)
		Thread.current[:tenant_id] = id
	end
	def self.current_id
		Thread.current[:tenant_id]
	end
end
