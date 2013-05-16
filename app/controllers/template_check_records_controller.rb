class TemplateCheckRecordsController < ApplicationController
	before_filter :check_point_already_done,:only=>[:create,:new]
	def new
		@template_report 						=current_resource
		@template_check_record 					= 
		TemplateCheckRecord.build_a_record(params[:template_check_record],@template_report)
		build_images
	end
	def create
		@template_report    		= current_resource
		@template_check_record 		= TemplateCheckRecord.build_a_record(params[:template_check_record],@template_report)
		if @template_check_record.save
			return redirect_to template_check_record_path(@template_check_record)
		else
			build_images
			render 'new'
		end
	end
	def edit
		@template_check_record = current_resource
		build_images
	end

	def update
		@template_check_record = current_resource
		if @template_check_record.update_attributes(params[:template_check_record])
			return redirect_to template_check_record_path(@template_check_record)
		else
			build_images
			render 'edit'
		end
	end
	def show
		@template_check_record = current_resource
	end

	def destroy
		@template_check_record = current_resource
		@template_check_record.destroy
		return redirect_to template_report_path(@template_check_record.template_report)
	end

	private 
	def current_resource
		if params[:template_report_id]
			@current_resource ||= TemplateReport.find(params[:template_report_id])
		elsif params[:id]
			@current_resource ||= TemplateCheckRecord.find(params[:id])
		end
  	end
  	def build_images
  		build_images_for_object(@template_check_record)
  		if @template_check_record.issue.nil?
			@template_check_record.build_issue
		end
		build_images_for_object(@template_check_record.issue)
  	end
  	def check_point_already_done
  		if current_resource
  			if current_resource.template_check_records.find{|tcr| tcr.check_point_id == params[:template_check_record][:check_point_id].try(:to_i)}
  				return redirect_to template_report_path(current_resource)
  			end
  		end	
  	end
end
