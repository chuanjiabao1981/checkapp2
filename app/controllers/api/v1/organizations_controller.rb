module Api
	module V1
		class OrganizationsController < ApiController
			def users
				@users = User.all_subordinates_of_organization(params[:organization_id])
				@c = @users.collect {|u| [u.name,u.id]}
				render :inline => "<%= options_for_select @c %>"
			end
		end
	end
end