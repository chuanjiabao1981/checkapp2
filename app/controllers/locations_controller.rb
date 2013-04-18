class LocationsController < ApplicationController
	def index
		@locations = Location.all
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
end
