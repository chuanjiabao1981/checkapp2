class UsersController < ApplicationController
	def index
		@users = User.includes(:organization).all
	end
	def new
		@user  = User.new
	end
	def create
		@user = User.new_user(current_user,params[:user])
		if @user && @user.save
			return redirect_to users_path
		else
			render 'new'
		end		
	end
	def edit
		@user = current_resource
	end
	def update
		@user = current_resource
		if @user.update_attributes(params[:user])
			return redirect_to users_path
		else
			render 'edit'
		end
	end
	def destroy
		@user = current_resource
		@user.destroy
		return redirect_to users_path
	end
	private
		def current_resource
    		@current_resource ||= User.find(params[:id]) if params[:id]
  		end
end
