class TenantsController < ApplicationController
	before_filter :nil_tenat ,:only => [:edit,:update,:destroy]
	def index
		@tenants = Tenant.all
	end
	def new
		@tenat = Tenant.new
	end
	def create
		@tenat = Tenant.new(params[:tenant])
		if @tenat.save
			return redirect_to tenants_path
		else
			render 'new'
		end
	end
	def edit
	end
	def update
		if @tenat.update_attributes(params[:tenant])
			redirect_to tenants_path
		else
			render 'edit'
		end
	end
	def destroy
		@tenat.destroy
		return redirect_to tenants_path
	end
	private
		def nil_tenat
			@tenat = Tenant.find_by_id(params[:id])
			return redirect_to tenats_path if @tenat.nil?
		end
end
