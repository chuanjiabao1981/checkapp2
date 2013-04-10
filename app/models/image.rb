class Image < ActiveRecord::Base
	require 'carrierwave/orm/activerecord'
	validates :tenant 			,presence: true

	mount_uploader :image,ImageUploader
	belongs_to :image_attachment,:polymorphic => true
	belongs_to :tenant
end
