class TemplateReport < ActiveRecord::Base
  belongs_to :template
  belongs_to :submitter,	:class_name=>"User",:foreign_key => "submitter_id"
  belongs_to :tenant
  has_many   :template_check_records,:dependent => :destroy
  validates :template,:presence => true

  
  default_scope { where(tenant_id: Tenant.current_id)  if Tenant.current_id }
  scope :latest_template_reports,lambda { includes(:template_check_records,:submitter,:template).order('created_at DESC').limit(10)}




  def un_check_points
  	u = []
  	self.template.check_points.reverse.each do |c|
  		u << c unless self.template_check_records.index {|record| record.check_point_id == c.id}
  	end
  	u
  end
end
