module Api
	module V1
		module SessionsHelper
			def login_success_json(user)
				json_add_data(:token_key,"_remember_token")
				json_add_data(:token_value,user.remember_token)
			end
		end
	end
end