#encoding:utf-8
class TemplateReportsController < ApplicationController
	def index
		@template_reports = TemplateReport.paginate(:page => params[:page]).order('template_reports.created_at DESC')
	end
	def new
		@template_report = current_user.template_reports.build
	end
	def create
		@template_report = current_user.template_reports.build(params[:template_report])
		if @template_report.save
			#TODO　改成to show
			return redirect_to template_reports_path
		else
			render 'new'
		end
	end
	private 
	def current_resource
    		@current_resource ||= TemplateReport.find(params[:id]) if params[:id]
    end
end
