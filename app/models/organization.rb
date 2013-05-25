class Organization < ActiveRecord::Base
	validates :name    ,:length => {:maximum => 100}, :presence => true
	validates :address ,:length => {:maximum => 200}, :presence => true
	validates :manager ,:presence => true
	belongs_to :tenant
	belongs_to :manager,:class_name =>"User",:inverse_of => :organization
	belongs_to :super_organization,:class_name =>"Organization"
	has_many  :sub_organizations,:class_name => "Organization",:foreign_key => "super_organization_id"
	default_scope { where(tenant_id: Tenant.current_id)  if Tenant.current_id }
end
