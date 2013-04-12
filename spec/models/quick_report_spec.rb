#encoding:utf-8
require 'spec_helper'

describe QuickReport  do
	subject {@quick_report}
	describe "Use new"  do
		let(:user_as_member) {FactoryGirl.build(:user_as_member)}
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
end
