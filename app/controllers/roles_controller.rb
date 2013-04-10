class RolesController < ApplicationController
	before_filter :nil_role, only:[:edit,:update,:destroy]
	def index
		@roles = Role.all
	end
	def new
		@role = Role.new
	end
	def create
		@role = Role.new(params[:role])
		if @role.save
			redirect_to roles_path
		else
			render 'new'
		end
	end
	def edit
	end
	def update
		if @role.update_attributes(params[:role])
			redirect_to roles_path
		else
			render 'edit'
		end
	end
	def destroy
		@role.destroy
		redirect_to roles_path
	end
	private
		def nil_role
			@role = Role.find_by_id(params[:id])
			redirect_to roles_path if @role.nil?
		end
end
