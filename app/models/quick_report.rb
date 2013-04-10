class QuickReport < ActiveRecord::Base
	validates :tenant		, presence: true
	has_one   :issue 		, :as => :issuable, :dependent => :destroy
	belongs_to :tenant
	default_scope { where(tenant_id: Tenant.current_id)  if Tenant.current_id }
end
