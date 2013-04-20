class LocationsController < ApplicationController
	def index
		if params[:search]
			@locations = Location.where("name like ?","%#{params[:search][:name]}%").paginate(:page => params[:page],:per_page => 2)
		else
			@locations = Location.paginate(:page => params[:page],:per_page => 2)
		end
	end
	def new
		@location = Location.new
	end
	def create
		@location = Location.new(params[:location])
		if @location.save
			return redirect_to locations_path
		else
			render 'new'
		end
	end
	def edit
		@location = current_resource
	end
	def update
		@location = current_resource
		if @location.update_attributes(params[:location])
			return redirect_to locations_path
		else
			render 'edit'
		end
	end
	def destroy
		@location = current_resource
		@location.destroy
		return redirect_to locations_path
	end
	private 
	def current_resource
    		@current_resource ||= Location.find(params[:id]) if params[:id]
    end
end
