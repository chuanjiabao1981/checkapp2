#encoding:utf-8
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

	def track
		if params[:track] and not params[:track].values.all? {|v| v.length == 0}
			# user 不能为null
			@track_points 		= TrackPoint.by_user(params[:track][:user]).between(params[:track][:day],params[:track][:start_time],params[:track][:end_time]).all
			@track_user_name	= User.find_by_id(params[:track][:user])
			if @track_points.size == 0
				flash.now[:notice] ="没有相关跟踪数据"
			end
		else
			@track_points = []
			params[:track]= {}
			params[:track][:start_time] = "00:00"
			params[:track][:end_time]   =  Time.now.strftime '%H:%M'
			@track_user_name = ''
		end

	end
	def checkin
		if have_param?(:checkin)
		else
		end
	end
	private
		def current_resource
    		@current_resource ||= User.find(params[:id]) if params[:id]
  		end
  		def have_param?(name)
  			params[name] and not params[name].values.all? {|v| v.length == 0}
  		end
end
