class SessionsController < ApplicationController
	before_filter :already_signin , :only => [:new]
	def new
		render layout:'only_topbar'
	end
	
	def create
		@user = User.find_by_account(params[:session][:account])
		if @user && @user.authenticate(params[:session][:password])
			sign_in(@user)
			return redirect_to root_path
		else
			flash.now[:error] = I18n.t('session.errors.account_or_password')
			render 'new',layout:'only_topbar'
		end
	end
	def destroy
		sign_out
		return redirect_to root_path
	end
	private 
		def already_signin
			return redirect_to root_path if current_user
		end
end
