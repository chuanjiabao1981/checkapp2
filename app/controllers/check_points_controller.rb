class CheckPointsController < ApplicationController
	def new
		@template = current_resource
		@check_point = @template.check_points.build()
	end
	def current_resource
		if params[:template_id]
			@current_resource ||= Template.find(params[:template_id])
		elsif params[:id]
			@current_resource ||= CheckPoint.find(params[:id])
		end
  	end
end
