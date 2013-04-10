require 'spec_helper'

describe "Sessions" do
  before do  
    @user = FactoryGirl.create(:user_as_member)
  end

  describe "User Login Successfully"  do
  	before do 
      signin(@user)
  	end
    it "should have the content" do
      page.should_not have_link(I18n.t('views.text.signin'),href: signin_path)
      page.should     have_link(I18n.t('views.text.signout'),href: signout_path)
      #pp page.driver.cookies[:remember_token]
      #pp Capybara.current_session.driver.request.cookies["remember_token"]
      #pp @user.remember_token
      Capybara.current_session.driver.request.cookies["remember_token"].should == @user.remember_token.to_s
    end
  end
  describe "User Login Fail" do
    before do 
      visit signin_path
      fill_in I18n.t('helpers.label.session.account')   ,with: @user.account
      fill_in I18n.t('helpers.label.session.password')  ,with: @user.password + "wrong password"
      click_button I18n.t('views.text.signin')
    end
    it "should have the content" do
      #save_and_open_page
      page.should have_selector('div.alert.alert-error',text: I18n.t('session.errors.account_or_password'))
    end
  end
end
