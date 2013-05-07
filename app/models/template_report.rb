class TemplateReport < ActiveRecord::Base
  belongs_to :template
  belongs_to :submitter,	:class_name=>"User",:foreign_key => "submitter_id"
  belongs_to :tenant
  has_many   :template_check_records,:dependent => :destroy
  validates :template,:presence => true
  default_scope { where(tenant_id: Tenant.current_id)  if Tenant.current_id }
end
