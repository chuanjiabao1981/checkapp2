module Api
	module V1
		class SessionsController < ApiController
			def create
				user = User.find_by_account(params[:session][:account])
				if user && user.authenticate(params[:session][:password])
					return render json:login_success_json(user)
				else
					return render json:json_base_warns(I18n.t('session.errors.account_or_password'))
				end
			end
		end
	end
end