#encoding:utf-8
module Overview
	def self.not_closed_issues
		Issue.includes(:location,:issuable).find(:all,:conditions=>["state!=? and location_id is not null","closed"])
	end
	def self.get_quick_report_issues_link(location,num)
		return "" if num == 0
		ActionController::Base.helpers.
		link_to("#{I18n.t('activerecord.models.quick_report')}发现#{num}个问题等待处理!",
					Rails.application.routes.url_helpers.search_quick_reports_path(
						{:search=>{:location=>location.id,:is_closed=>"false"}}
					)
				) 
	end
	def self.get_template_check_records_link(location,num)
		return "" if num == 0
		ActionController::Base.helpers.
		link_to("#{I18n.t('activerecord.models.template_report')}发现#{num}个问题等待处理!",
					Rails.application.routes.url_helpers.search_template_reports_path(
						{:search=>{:location=>location.id,:is_closed=>"false"}}
					)
				)
	end

	def self.locations_of_not_closed_issue
		issues = Overview.not_closed_issues
		t      = issues.group_by {|i| i.location }
		r      = []
		t.each do |location,issues|
			_l 								= location.as_json(:methods=>[:lat,:lng],:only=>[:name])
			_quick_report_num   			= issues.count {|i| i.issuable_type == 'QuickReport'}
			_template_check_record_num		= issues.count {|i| i.issuable_type == 'TemplateCheckRecord' and i.issuable.state == 'unpassed'}
			_l[:issue_info]		= "<div style='margin-top:10px;font-weight:bold'>" + 
								 	get_quick_report_issues_link(location,_quick_report_num)+
								 "<br/>" +
								 	get_template_check_records_link(location,_template_check_record_num)
								 "</div>"
			r<<_l
		end
		r
	end
	 

	def self.quick_reports_of_last_day(d=7)
		Overview._issues_of_last_day(QuickReport.last_day(d).group_by_created,d)
	end

	def self.template_check_records_of_last_day(d=7)
		Overview._issues_of_last_day(TemplateCheckRecord.by_unpassed_state.last_day(d).group_by_created,d)
	end

	def self._issues_of_last_day(issues,d=7)
		chart_data=[]
		__s 	  = {}
		7.downto(1) do |b|
			t = b.day.ago.strftime('%Y-%m-%d')
			s = issues.find {|s| s.issue_created_at_date == t}
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

	def self.unclosed_template_check_records_group_by_level
		s = TemplateCheckRecord.group_by_level.by_unpassed_state.closed_state('false')
		Issue::ISSUE_LEVEL_SET.inject({}) do |result,level|
			r = s.find {|q| q.level == level}
			if r.nil?
				result[level] = 0
			else
				result[level] = r.num
			end
			result
		end
	end
	def self.unclosed_quick_reports_group_by_level
		s=QuickReport.group_by_level.closed_state('false')
		Issue::ISSUE_LEVEL_SET.inject({}) do |result,level|
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
		QuickReport.includes(:issue=>[:resolve,:submitter,:responsible_person]).latest_quick_report
	end
	def self.latest_create_template_report
		TemplateReport.latest_template_reports
	end
end