class QuickReport < ActiveRecord::Base
	validates :tenant		, presence: true
	has_one   :issue 		, :as => :issuable, :dependent => :destroy
	belongs_to :tenant
	accepts_nested_attributes_for :issue

	default_scope { where(tenant_id: Tenant.current_id)  if Tenant.current_id }

	def self.new_quick_report_and_issue(params,current_user)
		a = QuickReport.new(params)
		a.issue.submitter = current_user
		a
	end
	def update_attributes(attributes)
		if self.issue
			if self.issue.can_change_responsible_person? && attributes[:issue_attributes]
				if attributes[:issue_attributes][:responsible_person_id].try(:to_i) != self.issue.responsible_person_id
					attributes[:issue_attributes][:state_event] = "change_responsible_person"
				end
			end
		end
		super(attributes)
	end
end
