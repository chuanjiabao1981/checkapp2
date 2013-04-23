class MainController < ApplicationController
	def overview
		#@not_close_issues 					= Overview.not_closed_issues
		@locations_of_not_closed_issue		= Overview.locations_of_not_closed_issue
	end
end
