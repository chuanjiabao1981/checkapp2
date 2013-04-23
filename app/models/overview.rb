module Overview
	def self.not_closed_issues
		Issue.joins(:location).find(:all,:conditions=>["state!=? and location_id is not null","closed"])
	end

	def self.locations_of_not_closed_issue
		issues = Overview.not_closed_issues
		t      = issues.group_by {|i| i.location }
		r      = []
		t.each do |location,issues|
			_l 					= location.as_json(only:[:name,:lat,:lng,:id])
			_l[:issue_num]		= issues.size
			r<<_l
		end
		r
	end
end