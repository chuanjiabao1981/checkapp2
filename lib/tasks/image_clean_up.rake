namespace :images do 
	task :cleanup => :environment do
		ten_minutes_ago = 10.minutes.ago
		rubish_images =Image.where("image_attachment_id is null and created_at < ?",ten_minutes_ago)
		rubish_images.each do |img|
			img.destroy
			pp img.image.path
		end
		tmp_dir = '/tmp/2013-05-22-1369211208/'
		i = 0
		Dir.glob("#{tmp_dir}/[0-9]/*") do |f|
			i++
			if File.ctime(f) < ten_minutes_ago
				File.delete(f)
				pp f
			end
			break if i > 2;
		end
	end	
end