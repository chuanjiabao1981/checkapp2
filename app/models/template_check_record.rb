class TemplateCheckRecord < ActiveRecord::Base
	belongs_to :template_report
	belongs_to :check_point
	belongs_to :submitter,	:class_name=>"User",:foreign_key => "submitter_id"
	belongs_to :tenant

	has_one  :issue	,	:as => :issuable, :dependent => :destroy
	has_many :videos,	:as => :video_attachment,:dependent => :destroy
	has_many :images,	:as => :image_attachment,:dependent => :destroy

	validates :template_report    ,presence: true
	validates :submitter 		  ,presence: true
	validates :check_point		  ,presence: true
	validates :desc 			,:length => {:maximum => 1024}


	default_scope { where(tenant_id: Tenant.current_id)  if Tenant.current_id }


end
