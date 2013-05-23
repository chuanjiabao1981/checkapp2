class Image < ActiveRecord::Base
	require 'carrierwave/orm/activerecord'
	validates :tenant 			,presence: true

	mount_uploader :image,ImageUploader
	belongs_to :image_attachment,:polymorphic => true
	belongs_to :tenant
	default_scope { where(tenant_id: Tenant.current_id)  if Tenant.current_id }

	def thumb_url 
		self.image.thumb.url 
	end

end
