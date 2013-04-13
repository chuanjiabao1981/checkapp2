#encoding:utf-8
require 'spec_helper'

describe QuickReport  do
	subject {@quick_report}
	describe "Use new"  do
		let!(:user_as_member) {FactoryGirl.build(:user_as_member)}
		before do
			#千万注意这个测试完成后要nil
			Tenant.current_id			= user_as_member.tenant.id
			@quick_report       		= QuickReport.new
		end
		it "should valid " do
			should be_valid
			should respond_to(:issue)
			should respond_to(:tenant)
			Tenant.current_id 			= nil
		end
	end
	describe "Use FactoryGirl" do
		before do
			@quick_report= FactoryGirl.build(:quick_report)
		end
		it "should valid" do
			should be_valid
			should respond_to(:issue)
			should respond_to(:tenant)
		end
	end
	describe "Destroy QuickReport"  do
		before do
			@quick_report = FactoryGirl.create(:quick_report_with_issue) 
			@quick_report.should be_valid
		end
		it "destroy issue" do
			expect {@quick_report.destroy}.to change {Issue.count}.by(-1)
		end
	end
	describe "accepts_nested_attributes_for issue" do
		let(:user_as_member) {FactoryGirl.build(:user_as_member)}
		before do
			Tenant.current_id			= user_as_member.tenant.id
			k = 1.day.since.strftime("%Y-%m-%d")
			@quick_report_attribute 			= {quick_report: {issue_attributes:{level: "高",desc: "有问题",deadline: "#{k}"}}}
			@strong_quick_report_attribute 		= ActionController::Parameters.new(@quick_report_attribute)
		end
		it "should create issue" do
			lambda do
				qr = QuickReport.new_quick_report_and_issue(@quick_report_attribute[:quick_report],user_as_member)
				qr.save
			end.should change(Issue,:count).by(1)
			Tenant.current_id = nil
		end
		it "should create quick_report" do
			lambda do
				qr = QuickReport.new_quick_report_and_issue(@quick_report_attribute[:quick_report],user_as_member)
				qr.save
			end.should change(QuickReport,:count).by(1)
		end
		it "should create issue" do
			user_permission=Permissions.permission_for(user_as_member)
			user_permission.permit_params! @strong_quick_report_attribute
			lambda do
				qr = QuickReport.new_quick_report_and_issue(@strong_quick_report_attribute[:quick_report],user_as_member)
				qr.save
			end.should change(Issue,:count).by(1)
		end
		it "should create quick_report" do
			user_permission=Permissions.permission_for(user_as_member)
			user_permission.permit_params! @strong_quick_report_attribute
			lambda do
				qr = QuickReport.new_quick_report_and_issue(@strong_quick_report_attribute[:quick_report],user_as_member)
				qr.save
			end.should change(QuickReport,:count).by(1)
		end
	end
end
