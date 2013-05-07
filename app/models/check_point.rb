class CheckPoint < ActiveRecord::Base
  belongs_to :tenant
  belongs_to :template
  validates :content    ,:length => {:maximum => 1024}
  default_scope { where(tenant_id: Tenant.current_id)  if Tenant.current_id }

end
