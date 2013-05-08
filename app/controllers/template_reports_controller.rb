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
			return redirect_to template_report_path(@template_report)
		else
			render 'new'
		end
	end
	def show
		@per_line		 = 6
		@template_report = current_resource
		@un_check_points = @template_report.un_check_points
	end
	private 
	def current_resource
    		@current_resource ||= TemplateReport.includes(
    			:tenant,
    			:template_check_records=>[
    										:issue,
    										:check_point,
    										:submitter
    									],
    			:template=>[:check_points,:tenant]).find(params[:id]) if params[:id]
    end
end
