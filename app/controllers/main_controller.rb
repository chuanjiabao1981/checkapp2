class MainController < ApplicationController
	before_filter :not_signin
	def overview
		@locations_of_not_closed_issue								= Overview.locations_of_not_closed_issue
		@y_distinct_value_num,@xcharts_data 						= Overview.quick_reports_of_last_day
		@unclosed_quick_reports_group_by_level 						= Overview.unclosed_quick_reports_group_by_level
		@latest_created_quick_report 								= Overview.latest_created_quick_report
	end
	private
		def not_signin
			return redirect_to signin_path unless current_user
		end
end
