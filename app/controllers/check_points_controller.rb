class CheckPointsController < ApplicationController
	def new
		@template = current_resource
		@check_point = @template.check_points.build()
	end
	def create
		@template 		= current_resource
		@check_point 	= @template.check_points.build(params[:check_point])
		if @check_point.save
			return redirect_to template_path(@template)
		else
			render 'new'
		end
	end
	def edit
		@check_point 	= current_resource
	end
	def update
		@check_point    = current_resource
		if @check_point.update_attributes(params[:check_point])
			return redirect_to template_path(@check_point.template)
		else
			render 'edit'
		end
	end
	def destroy
		@check_point = current_resource
		@check_point.destroy
		return redirect_to template_path(@check_point.template)
	end
	def current_resource
		if params[:template_id]
			@current_resource ||= Template.find(params[:template_id])
		elsif params[:id]
			@current_resource ||= CheckPoint.find(params[:id])
		end
  	end
end
