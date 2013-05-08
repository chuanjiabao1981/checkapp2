class TemplateCheckRecordsController < ApplicationController
	def new
		@template_report 						=current_resource
		@template_check_record 					= 
		TemplateCheckRecord.build_a_record(params[:template_check_record],current_user,@template_report)
		build_images_for_object(@template_check_record)
		@template_check_record.build_issue
		build_images_for_object(@template_check_record.issue)
	end
	def create
		@template_report    		= current_resource
		@template_check_record 		= TemplateCheckRecord.build_a_record(params[:template_check_record],current_user,@template_report)
		if @template_check_record.save
			#TODO 
			return redirect_to template_report_path(current_resource)
		else
			build_images_for_object(@template_check_record)
			if @template_check_record.issue.nil?
				@template_check_record.build_issue
			end
			Rails.logger.debug(@template_check_record.errors.full_messages)
			build_images_for_object(@template_check_record.issue)
			render 'new'
		end

	end
	private 
	def current_resource
		if params[:template_report_id]
			@current_resource ||= TemplateReport.find(params[:template_report_id])
		elsif params[:id]
			@current_resource ||= TemplateCheckRecord.find(params[:id])
		end
  	end
end
