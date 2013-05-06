#encoding:utf-8
class Location < ActiveRecord::Base
	set_rgeo_factory_for_column(:coordinate, RGeo::Geographic.spherical_factory(:srid => 4326))

	validates :name 			,:length => {:maximum => 128}, :presence => true
	validates_uniqueness_of		 :name

	include GeographyPoints
	extend GeographyPointsNew

	validates_with CoordinateValidator


	default_scope { where(tenant_id: Tenant.current_id)  if Tenant.current_id }
end
