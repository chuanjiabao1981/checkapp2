#encoding:utf-8
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
			_l[:issue_info]		= "<div style='margin-top:10px;font-weight:bold'>" + 
								 ActionController::Base.helpers.link_to("有#{issues.size}个问题等待处理!",
								 Rails.application.routes.url_helpers.search_quick_reports_path(
								 	{:search=>{:location=>location.id,:is_closed=>"false"}}
								 ))+
								 "</div>"
			r<<_l
		end
		r
	end

	def self.quick_reports_of_last_day(d=7)
		chart_data=[]
		k = QuickReport.last_day(d).group_by_created
		__s 	  = {}
		7.downto(1) do |b|
			t = b.day.ago.strftime('%Y-%m-%d')
			s = k.find {|s| s.issue_created_at_date == t}
			y = s.nil? ? 0 : s.num.to_i
			chart_data << {"x"=> t,"y" => y }
			__s[y]=1
		end

			[	__s.keys.size,
				{
						"xScale"=> "time",
  						"yScale"=> "linear",
						"main"=> [{
									"className"=> ".pizza",
									"data"=> chart_data
								}]
				}
			]
	end

	def self.unclosed_quick_reports_group_by_level
		s=QuickReport.group_by_level.closed_state('false')
		Issue::ISSUE_LEVEL_SET.inject({}) do |result,level|
			Rails.logger.debug(result)
			r = s.find {|q| q.level == level}
			if r.nil?
				result[level] = 0
			else
				result[level] = r.num
			end
			result
		end
	end
	def self.latest_created_quick_report
		QuickReport.latest_quick_report
	end
end