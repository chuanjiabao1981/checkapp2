class ResolvesController < ApplicationController
	def new
		@issue 		= current_resource
		@resolve    = Resolve.new
	end
	def create
		@issue 		= current_resource
		@resolve 	= @issue.build_a_resolve(params[:resolve],current_user)
		if @resolve.save
			return redirect_to quick_report_path(@issue.issuable)
		else
			render 'new'
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
