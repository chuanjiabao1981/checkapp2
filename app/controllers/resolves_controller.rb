class ResolvesController < ApplicationController
	def new
		@issue 		= current_resource
		@resolve    = Resolve.new
		build_images_for_object(@resolve )

	end
	def create
		@issue 		= current_resource
		@resolve 	= @issue.build_a_resolve(params[:resolve],current_user)
		if @resolve.save
			return redirect_to send("#{@issue.issuable_type.underscore}_path",@issue.issuable)
		else
			build_images_for_object(@resolve)
			render 'new'
		end
	end
	def edit
		@resolve = current_resource
		build_images_for_object(@resolve)
	end
	def update
		@resolve = current_resource
		if @resolve.update_attributes(params[:resolve])
			return redirect_to send("#{@resolve.issue.issuable_type.underscore}_path",@resolve.issue.issuable)
		else
			build_images_for_object(@resolve)
			render 'edit'
		end
	end
private
	def current_resource
		if params[:issue_id]
			@current_resource ||= Issue.find(params[:issue_id])
		elsif params[:id]
			@current_resource ||= Resolve.find(params[:id])
		end
  	end
end
