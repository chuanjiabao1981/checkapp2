require 'spec_helper'

def signin(user)
	visit signin_path
	fill_in I18n.t('helpers.label.session.account') 	,with: user.account
	fill_in I18n.t('helpers.label.session.password')	,with: user.password.nil? ? 'password' : user.password
	click_button I18n.t('views.text.signin')
	page.should have_content user.name
end