class QuickReportsController < ApplicationController
	def index
		@quick_reports = QuickReport.all
	end
	def new
		@quick_report = QuickReport.new
		@quick_report.build_issue
	end
	def create
		@quick_report = QuickReport.new_quick_report_and_issue(params[:quick_report],current_user)
		if @quick_report && @quick_report.save
			return redirect_to quick_reports_path
		else
			render 'new'
		end
	end
	def edit
		@quick_report = current_resource
	end
	def update
		@quick_report = current_resource
		if @quick_report.update_attributes(params[:quick_report]) 
			return redirect_to quick_reports_path
		else
			render 'edit'	
		end
	end
	def destroy
		@quick_report = current_resource
		@quick_report.destroy
		return redirect_to quick_reports_path
	end
	def show
		@quick_report = current_resource
	end
	def search 
		if params[:search] and not params[:search].values.all? {|v| v.length == 0}
			@quick_reports = QuickReport.search(params["search"])
		else
			params[:search] = {}
			@quick_reports = []
		end
	end
	private 
		def current_resource
    		@current_resource ||= QuickReport.find(params[:id]) if params[:id]
    	end
end
