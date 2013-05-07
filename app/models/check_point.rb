class CheckPoint < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :template
  validates :content    ,:length => {:maximum => 1024}
  validates :content    ,:presence => true

  has_many    :template_check_records,:dependent => :destroy

  default_scope { where(tenant_id: Tenant.current_id)  if Tenant.current_id }

end
