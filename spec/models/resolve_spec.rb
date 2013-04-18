require 'spec_helper'

describe Resolve do
	before do
		@resolve  = FactoryGirl.build(:resolve)
	end
	subject {@resolve}
	describe "Valid" do
		it {should be_valid}
		it {should respond_to(:submitter)}
		it {should respond_to(:videos)}
		it {should respond_to(:images)}

	end
	describe "Not Valid" do
		before do
			@resolve.should be_valid
		end
		describe "no tenant"  do
			before do
				@resolve.tenant = nil
			end
			it {should_not be_valid}
		end
		describe "no submitter" do
			before do
				@resolve.submitter = nil
			end
			it {should_not be_valid}
		end
	end
	describe "update a resolve" ,focus:true do 
		let(:user_as_member){FactoryGirl.create(:user_as_member)}
		let(:other_user_as_member){FactoryGirl.create(:user_as_member,tenant:user_as_member.tenant)}
		let(:quick_report) {FactoryGirl.create(:quick_report_with_issue_and_resolve,
											   issue_submitter: user_as_member,
											   responsible_person: other_user_as_member)}
		before do
			quick_report.issue.reject_resolve
			quick_report.issue.should be_valid
		end
		it "update should change issue state" do
			quick_report.issue.resolve.update_attributes({:desc=>"okokok"})
			quick_report.issue.resolve.desc.should == "okokok"
			quick_report.issue.should be_verifying_resolve

		end
	end
end
