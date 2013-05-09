class TemplatesController < ApplicationController
	def index
		@templates = Template.all
	end
	def new
		@template = Template.new
	end 
	def create
		@template = Template.new(params[:template])
		if @template.save
			return redirect_to templates_path
		else
			render 'new'
		end
	end
	def edit
		@template = current_resource
	end
	def show
		@template = current_resource
	end
	def update
		@template = current_resource
		if @template.update_attributes(params[:template])
			return redirect_to templates_path
		else
			render 'edit'
		end
	end
	def destroy
		@template = current_resource
		@template.destroy
		return redirect_to templates_path
	end

	private 
	def current_resource
    		@current_resource ||= Template.where('id=?',params[:id]).first if params[:id]
    end
end
