class Location < ActiveRecord::Base
	validates :name 			,:length => {:maximum => 128}, :presence => true
	validates_uniqueness_of		 :name
	validates :lng 		        ,:presence => true
	validates :lat 				,:presence => true
	validates_numericality_of :lng
	validates_numericality_of :lat
	default_scope { where(tenant_id: Tenant.current_id)  if Tenant.current_id }
end
