class Video < ActiveRecord::Base
	require 'carrierwave/orm/activerecord'
	validates :tenant 			,presence: true

	mount_uploader :video,VideoUploader
	belongs_to :video_attachment,:polymorphic => true
	belongs_to :tenant
	default_scope { where(tenant_id: Tenant.current_id)  if Tenant.current_id }

end
