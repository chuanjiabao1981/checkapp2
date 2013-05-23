namespace :images do 
	task :cleanup => :environment do
		rubish_images =Image.where("image_attachment_id is null and created_at < ?",10.minutes.ago)
		rubish_images.each do |img|
			img.destroy
			pp img.image.path
		end
	end	
end