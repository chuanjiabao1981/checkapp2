class Template < ActiveRecord::Base
  belongs_to :tenant
  validates :name    ,:length => {:maximum => 50} ,presence: true
  validates_uniqueness_of		 :name
  validates :desc    ,:length => {:maximum => 1024}
  has_many :check_points,:dependent => :destroy
  default_scope { where(tenant_id: Tenant.current_id)  if Tenant.current_id }
end
