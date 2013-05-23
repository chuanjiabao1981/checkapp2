namespace :images do 
	task :cleanup => :environment do
		ten_minutes_ago = 10.minutes.ago
		rubish_images =Image.where("image_attachment_id is null and created_at < ?",ten_minutes_ago)
		rubish_images.each do |img|
			img.destroy
			puts img.image.path
		end
	end	
end