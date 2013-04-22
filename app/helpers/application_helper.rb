#encoding:utf-8
module ApplicationHelper
	def menu
		return {
			main:{
					primary:{icon: "icon-home", label: "首页",link: root_path},
					items: {
						index: {icon: "icon-home", label: "首页", link: root_path}
					}
			},
			locations: {
				primary:{icon: "icon-map-marker", label: I18n.t('activerecord.models.location')},
				items: {
					index: {icon: "icon-th-list", label: I18n.t('activerecord.models.location')+I18n.t('views.text.index'),link: locations_path},
					new: {icon: "icon-pushpin" ,label:I18n.t('views.text.new') + I18n.t('activerecord.models.location'),link: new_location_path}
				}
			},
			users:{
				primary:{icon: "icon-user",label:I18n.t('activerecord.models.user')},
				items:{
					index:{icon: 'icon-list-alt',label: I18n.t('activerecord.models.user') + I18n.t('views.text.index'),link: users_path},
					new: {icon: 'icon-user-md', label: I18n.t('views.text.new') + I18n.t('activerecord.models.user'),link: new_user_path}
				}
			},
			organizations:{
				primary:{icon: "icon-building",label:I18n.t('activerecord.models.organization')},
				items:{
					index:{icon: 'icon-th-large',label: I18n.t('activerecord.models.organization') + I18n.t('views.text.index'),link: organizations_path},
					new: {icon: 'icon-plus-sign', label: I18n.t('views.text.new') + I18n.t('activerecord.models.organization'),link: new_organization_path}
				}
			},
			quick_reports:{
				primary:{icon: "icon-pencil",label:I18n.t('activerecord.models.quick_report')},
				items:{
					index:{icon: 'icon-list-ol',label: I18n.t('activerecord.models.quick_report') + I18n.t('views.text.index'),link: quick_reports_path},
					new: {icon: 'icon-magic', label: I18n.t('views.text.new') + I18n.t('activerecord.models.quick_report'),link: new_quick_report_path}
				}
			},
			signout:{
					primary:{icon: "icon-signout", label: "退出",link: signout_path, method: 'delete'},
					items: {
						index: {icon: "icon-signout", label: "退出", link: signout_path}
					}
			},
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
