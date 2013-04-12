class SubmitterValidator < ActiveModel::Validator
  def validate(record)
    unless record.submitter_id == record.issue.responsible_person_id
      record.errors[:base] << I18n.t('activerecord.errors.messages.resolve_submitter_not_match')
    end
  end
end

class Resolve < ActiveRecord::Base

	validates :desc				,:length => {:maximum => 1024}
	validates :submitter		,presence: true
	validates :issue			,presence: true
	validates :tenant 			,presence: true


	belongs_to :submitter,:class_name => "User",:foreign_key => "submitter_id"
	belongs_to :issue 
	belongs_to :tenant
	
	has_many :videos,:as => :video_attachment,:dependent => :destroy
	has_many :images,:as => :image_attachment,:dependent => :destroy



	default_scope { where(tenant_id: Tenant.current_id)  if Tenant.current_id }

	validates_with SubmitterValidator

end


