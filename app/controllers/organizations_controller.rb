class OrganizationsController < ApplicationController
	def index
		@organizations = Organization.paginate(:page => params[:page])
	end
	def new
		@organization = Organization.new
	end
	def create
		@organization = Organization.new(params[:organization])
		if @organization.save
			return redirect_to organizations_path
		else
			render 'new'
		end
	end
	def edit
		@organization = current_resource
	end
	def update
		@organization = current_resource
		if @organization.update_attributes(params[:organization])
			return redirect_to organizations_path
		else
			render 'edit'
		end
	end
	def destroy
		@organization = current_resource
		@organization.destroy
		return redirect_to organizations_path
	end
	private
		def current_resource
    		@current_resource ||= Organization.find(params[:id]) if params[:id]
  		end
end
