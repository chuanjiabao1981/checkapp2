class ImagesController < ApplicationController
	def create
		file = params[:qqfile].is_a?(ActionDispatch::Http::UploadedFile) ? params[:qqfile] : params[:file]
		@image = Image.new
		@image.image_attachment_type = params[:image_attachment_type]
		@image.image = file
		if @image.save
			render json: { 
							success: true, 
							src: render_to_string(partial: 'thumb.html.erb', locals: { image: @image })
 }
		else
			render json: @image.errors.to_json
		end
	end
	def destroy
		@image = current_resource
		@current_resource.destroy if @current_resource
	end
	private 
	def current_resource
		@current_resource ||= Image.find_by_id(params[:id]) if params[:id]
	end
end
