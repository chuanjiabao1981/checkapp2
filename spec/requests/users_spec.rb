#encoding: utf-8
require 'spec_helper'

describe "Users" do
	let(:user_as_super_admin)   {FactoryGirl.create(:user_as_super_admin)}
	let(:user_as_admin) 		{FactoryGirl.create(:user_as_admin)}
	let!(:user_as_member)		{FactoryGirl.create(:user_as_member,tenant:user_as_admin.tenant)}
	let!(:other_user_as_member)	{FactoryGirl.create(:user_as_member)}
	let!(:users_as_member)		{FactoryGirl.create_list(:user_as_member,4,tenant:user_as_admin.tenant)}
	subject{page}
  describe "index" do
  	describe "super_admin user" do
  		before do
  			signin(user_as_super_admin)
  			visit users_path
  		end
  		it "should have all users" do 
  			should 	   have_content other_user_as_member.account
  			should 	   have_content user_as_super_admin.account
  			should 	   have_content user_as_admin.account
  			users_as_member.each do |u|
  				should have_content u.account
  			end
  		end
  	end
  	describe "admin user" do
  		before do 
  			signin(user_as_admin)
  			visit users_path
  		end
  		it "should have users"  do
  			should_not have_content other_user_as_member.account
  			should_not have_content user_as_super_admin.account
  			should 	   have_content user_as_admin.account
  			users_as_member.each do |u|
  				should have_content u.account
  			end
  		end
  	end
  	describe "member user" do 
  		before do
  			signin(user_as_member)
  			visit users_path
  		end
  		it "should have users" do
  			should_not have_content other_user_as_member.account
  			should_not have_content user_as_super_admin.account
  			should 	   have_content user_as_admin.account
  			users_as_member.each do |u|
  				should have_content u.account
  			end
    	end
    end
    describe "guest user" do
      before do
        visit users_path
      end
      it "should no permission" do
        should have_content I18n.t('views.text.unauthorized')
      end
    end
	end
  describe "new and create" do
    describe "super_admin" do
      before do
        signin(user_as_super_admin)
        visit new_user_path
        fill_in I18n.t("activerecord.attributes.user.account"),with: "okokok"
        fill_in I18n.t("activerecord.attributes.user.name"), with: 'mll'
        fill_in I18n.t("activerecord.attributes.user.password"), with: "123456"
        fill_in I18n.t("activerecord.attributes.user.password_confirmation"),with: "123456"
        select users_as_member[0].name,from: I18n.t("activerecord.attributes.user.manager_id")
        select user_as_admin.tenant.name,from: I18n.t("activerecord.attributes.user.tenant_id")
        select Role.get_member.name,from: I18n.t("activerecord.attributes.user.role_id")
        click_button I18n.t("helpers.submit.create",model: I18n.t("activerecord.models.user"))
      end
      it 'should'  do
        should have_content 'okokok'
      end
    end
    describe "admin"  do
      before do 
        signin(user_as_admin)
        visit new_user_path
        fill_in I18n.t("activerecord.attributes.user.account"),with: "okokok"
        fill_in I18n.t("activerecord.attributes.user.name"), with: 'mll'
        fill_in I18n.t("activerecord.attributes.user.password"), with: "123456"
        fill_in I18n.t("activerecord.attributes.user.password_confirmation"),with: "123456"
        page.should_not have_select( I18n.t("activerecord.attributes.user.tenant_id"))
        click_button I18n.t("helpers.submit.create",model: I18n.t("activerecord.models.user"))
      end
      it "should have new user" do
        should have_content 'okokok'
      end
    end
    describe "member" do
      before do 
        signin(user_as_member)
        visit new_user_path
      end
      it "should not authorize" do
        should have_content I18n.t('views.text.unauthorized')
      end
    end
    describe "guest"   do
      before do
        signin(user_as_member)
        visit new_user_path
      end
      it "should not authorize" do
        should have_content I18n.t('views.text.unauthorized')
      end
    end
  end
  describe "update" do
    describe "super_admin" do
      before  do 
        signin(user_as_admin)
        visit edit_user_path(user_as_member)
        fill_in I18n.t("activerecord.attributes.user.account"),with: "newokokok"
        click_button I18n.t("helpers.submit.update",model: I18n.t("activerecord.models.user"))
      end
      it "should have new name"   do
        should have_content "newokokok"
      end
    end
    describe "admin"  do
      describe "normal" do
        before  do 
          signin(user_as_admin)
          visit edit_user_path(user_as_member)
          fill_in I18n.t("activerecord.attributes.user.account"),with: "newokokok"
          page.should_not have_select(I18n.t("activerecord.attributes.user.tenant_id"))
          click_button I18n.t("helpers.submit.update",model: I18n.t("activerecord.models.user"))
        end
        it "should have new name"  do
          should have_content "newokokok"
        end
      end
      describe "update tenant"   do
        before do
          post sessions_path,session:{ account: user_as_admin.account, password: user_as_admin.password}
          put  user_path(user_as_member) ,user:{tenant_id:"22",name:"newokokok"}
        end
        it "should_not effect"   do
          User.last.tenant == user_as_admin.tenant
          User.last.name  == "newokokok"
        end
      end
      describe "update other tenant user" do
        before do 
          signin(user_as_admin)
          visit edit_user_path(other_user_as_member)
        end
        it "should not authorize" do
          should have_content I18n.t('views.text.unauthorized')
        end
      end
    end
    describe "member" do
      before do 
        signin(user_as_member)
        visit edit_user_path(user_as_member)
      end

      it "shuld not authorize"  do
        should have_content I18n.t('views.text.unauthorized')
      end
    end
    describe "guest" do
      before do
        visit edit_user_path(user_as_member)
      end
      it "should not authorize" do
        should have_content I18n.t('views.text.unauthorized')
      end
    end
  end
  describe "destroy" do
    describe "super_admin" do
      before do 
        signin user_as_super_admin
        visit users_path
        find("a[href=\"#{user_path(other_user_as_member)}\"]").click
      end
      it "should not have the delete user" do
          should_not have_content other_user_as_member.account
      end
    end
    describe "admin" do
      describe "own member"  do
        before do 
          signin user_as_admin
          visit users_path
          find("a[href=\"#{user_path(user_as_member)}\"]").click
        end
        it "should not have the delete user" do
          should_not have_content user_as_member.account
        end
      end
      describe "other member" do
        before do 
          signin user_as_admin
          page.driver.submit :delete, user_path(other_user_as_member) ,{}
        end 
        it "should not authorise" do
          should have_content I18n.t('views.text.unauthorized')
        end
      end
    end
    describe "member" do
      before do
        signin user_as_member
        page.driver.submit :delete, user_path(other_user_as_member) ,{}
      end
      it "should not authorize" do
        should have_content I18n.t('views.text.unauthorized')
      end
    end
    describe "guest" do
      before do
       page.driver.submit :delete, user_path(other_user_as_member) ,{}
      end
      it "should not authorize" do
        should have_content I18n.t('views.text.unauthorized')
      end
    end
  end
end
