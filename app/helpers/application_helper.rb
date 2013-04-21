#encoding:utf-8
module ApplicationHelper
	def menu
		return {
			main:{
					primary:{icon: "icon-dashboard", label: "首页",link: root_path},
					items: {
						index: {icon: "icon-dashboard", label: "首页", link: root_path}
					}
			},
			locations: {
				primary:{icon: "icon-dashboard", label: I18n.t('activerecord.models.location')},
				items: {
					index: {icon: "icon-dashboard", label: I18n.t('activerecord.models.location')+I18n.t('views.text.index'),link: locations_path},
					new: {icon: "icon-dashboard" ,label:I18n.t('views.text.new') + I18n.t('activerecord.models.location'),link: new_location_path}
				}
			}
		}
	end
	def nav_active(options = {})
    	if options[:secondary] and options[:primary]
    	  return "active" if options[:secondary] == action_name and options[:primary] == controller_name
    	elsif options[:primary]
      		return "active" if options[:primary] == controller_name 
    	end
	end
	def nav_collapse(options = {})
    	return "collapsed" unless options[:primary] == controller_name
  	end
	def random_string(length=10)
    	chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789'
    	password = ''
    	length.times { password << chars[rand(chars.size)] }
    	password
  	end
end
