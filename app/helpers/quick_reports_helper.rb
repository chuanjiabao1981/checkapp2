module QuickReportsHelper
	def build_images_for_object(f)
		num = 3 - f.images.size 
		(1..num).each do 
			f.images.build
		end
	end
end
