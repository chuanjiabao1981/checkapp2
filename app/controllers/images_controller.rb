class ImagesController < ApplicationController
	def create
		@image = Image.new
		@image.image_attachment_type = params[:image_attachment_type]
		@image.uuid = params["X-Progress-ID"]
		@image.image = ActionDispatch::Http::UploadedFile.new({
        :filename => params[:original_name],
        :type => params[:content_type],
        :head => nil,
        :tempfile => File.open(params[:filepath])
      	})
		if @image.save
			render json: { 
							success: true, 
							src: render_to_string(partial: 'thumb.html.erb', locals: { image: @image,image_check_box_name:params[:image_check_box_name] }),
						    id: @image.id

 }
		else
			Rails.logger.debug(@image.errors.full_messages.to_sentence)
			render json: {error: @image.errors.full_messages.to_sentence}
		end
	end
	def destroy
		@image = current_resource
		@current_resource.destroy if @current_resource
	end
	private 
	def current_resource
		if params[:id] 
			if params[:id].include?("-")
				@current_resource ||= Image.find_by_uuid(params[:id])
			else
				@current_resource ||= Image.find_by_id(params[:id]) 
			end
			@current_resource
		end
	end
end
