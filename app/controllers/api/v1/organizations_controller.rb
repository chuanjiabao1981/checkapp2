module Api
	module V1
		class OrganizationsController < ApiController
			def users
				#@users = User.all_subordinates_of_organization(params[:organization_id])
				@users = Organization.all_organization_users(params[:organization_id])
				@c = @users.collect {|u| [u.name,u.id]}
				@c.insert(0,["",])
				render :inline => "<%= options_for_select @c %>"
			end
		end
	end
end