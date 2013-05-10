#encoding:utf-8
module ApplicationHelper
	## 默认所有的action都会出现在breadcrumb
	## 但是并不是所有的都会出现在sidebar中
	def menu
		 return  {
			main:{
					primary:{icon: "icon-bar-chart", label: "概况",link: root_path},
					items: {
						overview: {
								icon: 		"icon-bar-chart", 
								label: 		"概况", 
								link: 		root_path, 
								side_nav: 	true
							  }
					}
			},
			tenants:{
					primary:{icon: 'icon-qrcode', label: I18n.t('activerecord.models.tenant'),link: tenants_path},
					items: {
						index: {
								 icon: 		'icon-sitemap',
								 label: 	I18n.t('activerecord.models.tenant') + I18n.t('views.text.index'),
								 link: 		tenants_path,
								 side_nav:  true
							   },
						new:   {
								 icon:      'icon-list-alt',
								 label:     I18n.t('views.text.new') + I18n.t('activerecord.models.tenant'),
								 link: 		new_tenant_path,
								 side_nav:  true
							   },
						create:   {
								 icon:      'icon-list-alt',
								 label:     I18n.t('views.text.new') + I18n.t('activerecord.models.tenant'),
								 link: 		new_tenant_path,
								 side_nav:  false
							   },
						edit:  {
								 icon: 		'icon-file',
								 label: 	I18n.t('views.text.edit') + I18n.t('activerecord.models.user'),
								 side_nav:   false
						},
						update:  {
								 icon: 		'icon-file',
								 label: 	I18n.t('views.text.edit') + I18n.t('activerecord.models.user'),
								 side_nav:   false
						}
					}

			},
			users:{
				primary:{icon: "icon-user",label:I18n.t('activerecord.models.user')},
				items:{
					index: {
							  icon:     'icon-list-alt',
							  label:     I18n.t('activerecord.models.user') + I18n.t('views.text.index'),
							  link:      users_path,
							  side_nav:  true
						   },
					new:   {
							  icon: 	'icon-user-md', 
							  label:     I18n.t('views.text.new') + I18n.t('activerecord.models.user'),
							  link:      new_user_path,
							  side_nav:  true
							},
					create:   {
							  icon: 	'icon-user-md', 
							  label:     I18n.t('views.text.new') + I18n.t('activerecord.models.user'),
							  link:      new_user_path,
							  side_nav:  false
							},
					show:  { 
							  icon: 		'icon-file-alt',
							  label:      I18n.t('views.text.show') + I18n.t('activerecord.models.user')	,
							  side_nav:   false
						},
					edit:{
								icon: 		'icon-file',
								label: 		I18n.t('views.text.edit') + I18n.t('activerecord.models.user'),
								side_nav:   false
						},
					update:{
								icon: 		'icon-file',
								label: 		I18n.t('views.text.edit') + I18n.t('activerecord.models.user'),
								side_nav:   false
						},
					track:{
								icon: 		'icon-search',
								label:      I18n.t('activerecord.models.track_point'),
								link: 		track_users_path,
								side_nav:   true

						  }
				}
			},
			organizations:{
				primary:{icon: "icon-building",label:I18n.t('activerecord.models.organization')},
				items:{
					index:{
							icon: 		'icon-th-large',
							label: 		I18n.t('activerecord.models.organization') + I18n.t('views.text.index'),
							link:   	organizations_path,
							side_nav: 	true

						  },
					new:  {
							icon:   	'icon-plus-sign',
							label:  	I18n.t('views.text.new') + I18n.t('activerecord.models.organization'),
							link:   	new_organization_path,
							side_nav:   true
						  },
					create:  {
							icon:   	'icon-plus-sign',
							label:  	I18n.t('views.text.new') + I18n.t('activerecord.models.organization'),
							link:   	new_organization_path,
							side_nav:   false
						  },
					edit:{
								icon: 		'icon-file',
								label: 		I18n.t('views.text.edit') + I18n.t('activerecord.models.organization'),
								side_nav:   false
						},
					update:{
								icon: 		'icon-file',
								label: 		I18n.t('views.text.edit') + I18n.t('activerecord.models.organization'),
								side_nav:   false
						}
				}
			},
			templates: {
				primary:{icon: "icon-table",label:I18n.t('activerecord.models.template')},
				items:{
					index: {
						icon: 'icon-list-alt',
						label: get_index_label('template'),
						link: templates_path,
						side_nav: true
					},
					create:{
						icon: 'icon-plus-sign',
						label: get_new_label('template'),
						side_nav: false
					},
					new: {
						icon: 'icon-plus-sign',
						label: get_new_label('template'),
						link: new_template_path,
						side_nav: true
					},
					show: {
						icon: 'icon-th-list',
						label: get_show_label('template'),
						side_nav: false
					},
					edit:{
						icon: 'icon-th-list',
						label: get_edit_label('template'),
						side_nav:  false
					},
					update:{
						icon: 'icon-th-list',
						label: get_edit_label('template'),
						side_nav:  false
					}
				}
			},
			quick_reports:{
				primary:{icon: "icon-pinterest",label:I18n.t('activerecord.models.quick_report')},
				items:{
						index:{
								icon: 		'icon-list-ol',
								label: 		I18n.t('activerecord.models.quick_report') + I18n.t('views.text.index'),
								link: 		quick_reports_path,
								side_nav: 	true
							  },
						new: {
								icon: 		'icon-magic', 
								label: 		I18n.t('views.text.new') + I18n.t('activerecord.models.quick_report'),
								link: 		new_quick_report_path,
								side_nav: 	true
							},
						create: {
								icon: 		'icon-magic', 
								label: 		I18n.t('views.text.new') + I18n.t('activerecord.models.quick_report'),
								link: 		new_quick_report_path,
								side_nav: 	false
						},
						show: {
								icon: 		'icon-file-alt',
								label:      I18n.t('views.text.show') + I18n.t('activerecord.models.quick_report')	,
								side_nav:   false
							},
						edit:{
								icon: 		'icon-file',
								label: 		I18n.t('views.text.edit') + I18n.t('activerecord.models.quick_report'),
								side_nav:   false
							},
						update:{
								icon: 		'icon-file',
								label: 		I18n.t('views.text.edit') + I18n.t('activerecord.models.quick_report'),
								side_nav:   false
							},
						search:{
								icon: 		'icon-search',
								label: 		I18n.t('views.text.search'),
								link: 		search_quick_reports_path,
								side_nav:   true
						}
				}
			},
			template_reports:{
				primary:{icon: "icon-pencil",label:I18n.t('activerecord.models.template_report')},
				items:{
					index: {
						icon: 'icon-tasks',
						label: get_index_label('template_report'),
						link: template_reports_path,
						side_nav: true
					},
					create:{
						icon: 'icon-th-list',
						label: get_new_label('template_report'),
						side_nav: false
					},
					new: {
						icon: ' icon-sitemap',
						label: get_new_label('template_report'),
						link: new_template_report_path,
						side_nav: true
					},
					show: {
						icon: 'icon-th-list',
						label: get_show_label('template_report'),
						side_nav: false
					},
					edit:{
						icon: 'icon-th-list',
						label: get_edit_label('template_report'),
						side_nav:  false
					},
					update:{
						icon: 'icon-th-list',
						label: get_edit_label('template_report'),
						side_nav:  false
					},
					search:{
								icon: 		'icon-search',
								label: 		I18n.t('views.text.search'),
								link: 		search_template_reports_path,
								side_nav:   true
					}
				}

			},
			resolves:{
				primary:{icon: "icon-cog",label:I18n.t('activerecord.models.resolve')},
				items:{
						new:  {
								icon: 		'icon-magic',
								label: 		I18n.t('views.text.new') + I18n.t('activerecord.models.resolve'),
								side_nav:   false
						},
						create:  {
								icon: 		'icon-magic',
								label: 		I18n.t('views.text.new') + I18n.t('activerecord.models.resolve'),
								side_nav:   false
						},
						show: {
								icon: 		'icon-file-alt',
								label: 		I18n.t('views.text.show') + I18n.t('activerecord.models.resolve'),
								side_nav:   false
							},
						edit:{
								icon: 		'icon-file',
								label: 		I18n.t('views.text.edit') + I18n.t('activerecord.models.resolve'),
								side_nav: 	false
							},
						update:{
								icon: 		'icon-file',
								label: 		I18n.t('views.text.edit') + I18n.t('activerecord.models.resolve'),
								side_nav: 	false
							}
				}
			},
			locations: {
				primary:{icon: "icon-globe", label: I18n.t('activerecord.models.location')},
				items: {
						index: {
								 icon: 		"icon-th-list", 
								 label: 	I18n.t('activerecord.models.location')+I18n.t('views.text.index'),
								 link: 		locations_path,
								 side_nav: 	true
								},
						new: {
								icon: 		"icon-pushpin" ,
								label: 		I18n.t('views.text.new') + I18n.t('activerecord.models.location'),
								link: 		new_location_path,
								side_nav: 	true
							},
						create: {
							icon: 		"icon-pushpin" ,
							label: 		I18n.t('views.text.new') + I18n.t('activerecord.models.location'),
							link: 		new_location_path,
							side_nav: 	false
						},
						edit:{
								icon: 		'icon-file',
								label: 		I18n.t('views.text.edit') + I18n.t('activerecord.models.location'),
								side_nav:   false
						},
						update:{
								icon: 		'icon-file',
								label: 		I18n.t('views.text.edit') + I18n.t('activerecord.models.location'),
								side_nav:   false
						}
				}
			},
			
			check_points: {
				primary:{icon: "icon-map-marker",label:I18n.t('activerecord.models.check_point')},
				items:{
					new: {
						icon: 'icon-th-list',
						label: get_new_label('check_point'),
						side_nav: false
					},
					create:{
						icon: 'icon-th-list',
						label: get_new_label('check_point'),
						side_nav: false
					},
					show: {
						icon: 'icon-th-list',
						label: get_show_label('check_point'),
						side_nav: false
					},
					edit:{
						icon: 'icon-th-list',
						label: get_edit_label('check_point'),
						side_nav:  false
					},
					update:{
						icon: 'icon-th-list',
						label: get_edit_label('check_point'),
						side_nav:  false
					}
				}
			},
			
			template_check_records:{
				primary:{icon: "icon-cog",label:I18n.t('activerecord.models.template_check_record')},
				items:{
						new:  {
								icon: 		'icon-magic',
								label: 		I18n.t('views.text.new') + I18n.t('activerecord.models.template_check_record'),
								side_nav:   false
						},
						create:  {
								icon: 		'icon-magic',
								label: 		I18n.t('views.text.new') + I18n.t('activerecord.models.template_check_record'),
								side_nav:   false
						},
						show: {
								icon: 		'icon-file-alt',
								label: 		I18n.t('views.text.show') + I18n.t('activerecord.models.template_check_record'),
								side_nav:   false
							},
						edit:{
								icon: 		'icon-file',
								label: 		I18n.t('views.text.edit') + I18n.t('activerecord.models.template_check_record'),
								side_nav: 	false
							},
						update:{
								icon: 		'icon-file',
								label: 		I18n.t('views.text.edit') + I18n.t('activerecord.models.template_check_record'),
								side_nav: 	false
							}
				}
			},
			signout:{
					primary:{icon: "icon-signout", label: "退出",link: signout_path, method: 'delete'},
					items: {
						index: {
								icon: 		"icon-signout", 
								label: 		"退出", 
								link: 		signout_path,
								side_nav: 	true
							}
					}
			}
		}
	end
	def side_nav_count(items = {})
		n = 0
		items.each do |k,v|
			n=n+1 if v[:side_nav]
		end
		n
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
  	def random_numbers(count, from=3, to=30)
    	count.times.map{ from + Random.rand(to-from) }
	end
	def get_all_location_num
		@_all_location_num ||= Location.count
	end
	def get_all_quick_report_num
		@_all_quick_report_num ||= QuickReport.count
	end
	def get_all_organization_num
		@_all_organization_num ||= Organization.count
	end

	 
	def get_index_label(model)
		I18n.t("activerecord.models.#{model}")+I18n.t('views.text.index')
	end
	def get_new_label(model)
		I18n.t('views.text.new') + I18n.t("activerecord.models.#{model}")
	end
	def get_show_label(model)
		I18n.t('views.text.show') + I18n.t("activerecord.models.#{model}")
	end
	def get_edit_label(model)
		I18n.t('views.text.edit') + I18n.t("activerecord.models.#{model}")
	end
end
