module ImagesHelper
	IMAGE_NUM= 3
	def build_issue_images_field_from_nginx(issuable_type,params)
		params[issuable_type]["issue_attributes"]["images_attributes"] ||= {}
		params[:images]  											   ||= []
		k 		= params[issuable_type]["issue_attributes"]["images_attributes"]
		images 	= params[:images] 
		(0..IMAGE_NUM-1).each do |i|
			if k[i.to_s]
				k.delete(i.to_s)
			else
				k[i.to_s] = new_a_image(images.shift) if images.length > 0
			end
		end
		params.permit!
	end

	private 
	def new_a_image(param)
		{
		"image"=>ActionDispatch::Http::UploadedFile.new({
        :filename => param[:original_name],
        :type => param[:content_type],
        :head => nil,
        :tempfile => File.open(param[:filepath])
      	})
		}
	end
end
