module UtilsHelper
	def check_box_name_of_issue_images(issue)
		name ="#{issue.issuable_type.underscore}[#{issue.class.to_s.underscore}_attributes][image_ids][]"
	end
	def check_box_name_of_image(o)
		name = "#{o.class.to_s.underscore}[image_ids][]"
	end
end
