class QuickReport < ActiveRecord::Base
	validates :tenant		, presence: true
	has_one   :issue 		, :as => :issuable, :dependent => :destroy
	belongs_to :tenant
	accepts_nested_attributes_for :issue

	default_scope { where(tenant_id: Tenant.current_id)  if Tenant.current_id }

	scope :closed_state , lambda { |is_closed| 
		if not is_closed.nil? 
			if is_closed == 'true'
				joins(:issue).where("issues.state = ?","closed")
			elsif is_closed == 'false'
				joins(:issue).where("issues.state != ?","closed")
			end
		end
	}

	scope :by_location, lambda {|location| joins(:issue).where("issues.location_id = ?",location) unless location.nil? or location.empty? }

	scope :by_state, lambda {|state| joins(:issue).where('issues.state = ?',state) unless state.nil? or state.empty? }
	scope :by_level, lambda {|level| joins(:issue).where('issues.level = ?',level) unless level.nil? or level.empty? }
	#截至到d天前
	scope :day_ago, lambda {|d| joins(:issue).where('issues.created_at < ?',d.day.ago.beginning_of_day) unless d.nil? or d == 0}
	scope :exceed_deadline ,lambda { joins(:issue).where('issues.deadline is not null and issues.deadline < ? and issues.state != ? ',Date.current,"closed")}
	scope :group_by_created,lambda { joins(:issue).select('count(*) as num, DATE(issues.created_at) as issue_created_at_date').group('DATE(issues.created_at)')}
	scope :group_by_level, lambda  { joins(:issue).select('count(*) as num, issues.level as level').group('issues.level')}
	#最近d天的
	scope :last_day ,lambda {|d| joins(:issue).where('issues.created_at >?',d.day.ago.beginning_of_day)}

	scope :latest_quick_report,lambda { joins(:issue).order('issues.created_at DESC').limit(10)}

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

	def self.search(options)
		QuickReport.closed_state(options["is_closed"]).by_location(options[:location]).by_state(options[:state]).by_level(options[:level]).day_ago(options[:day].to_i)
	end
end
