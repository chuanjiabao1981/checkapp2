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
	describe "accepts_nested_attributes_for create issue" do
		let(:user_as_member) {FactoryGirl.build(:user_as_member)}
		before do
			Tenant.current_id			= user_as_member.tenant.id
			k = 1.day.since.strftime("%Y-%m-%d")
			@quick_report_attribute 			= {quick_report: {issue_attributes:{level: "高",desc: "有问题",deadline: "#{k}"}}}
			@strong_quick_report_attribute 		= ActionController::Parameters.new(@quick_report_attribute)
		end
		after do
			Tenant.current_id = nil
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
			Tenant.current_id = nil

		end
		it "should create issue" do
			user_permission=Permissions.permission_for(user_as_member)
			user_permission.permit_params! @strong_quick_report_attribute
			lambda do
				qr = QuickReport.new_quick_report_and_issue(@strong_quick_report_attribute[:quick_report],user_as_member)
				qr.save
			end.should change(Issue,:count).by(1)
			Tenant.current_id = nil
		end
		it "should create quick_report" do
			user_permission=Permissions.permission_for(user_as_member)
			user_permission.permit_params! @strong_quick_report_attribute
			lambda do
				qr = QuickReport.new_quick_report_and_issue(@strong_quick_report_attribute[:quick_report],user_as_member)
				qr.save
			end.should change(QuickReport,:count).by(1)
			Tenant.current_id = nil
		end
		it "should not create quick_report and isssue"  do
			quick_report_num  =QuickReport.count
			lambda do
				qr 			= QuickReport.new_quick_report_and_issue(@quick_report_attribute[:quick_report],user_as_member)
				qr.tenant 	=nil
				qr.save
			end.should_not change(Issue,:count).from(0)
		end
	end
	describe "accepts_nested_attributes_for update issue"  do
		before do
			@issue_submitter 				=FactoryGirl.create(:user_as_member)
			@responsible_person				=FactoryGirl.create(:user_as_member,tenant: @issue_submitter.tenant)
			@other_responsible_person		=FactoryGirl.create(:user_as_member,tenant: @issue_submitter.tenant)	
			@quick_report 					=FactoryGirl.create(:quick_report_with_issue_and_resolve,
															    issue_submitter: @issue_submitter,
															    responsible_person:@responsible_person)		
			@quick_report_update_atrribtes	= { quick_report: 
												 {issue_attributes:
												 	{
												 		id: @quick_report.issue.id,
												 		level: "中",
												 		responsible_person_id: @other_responsible_person.id
												 	}
												 }
											  }
			if @quick_report_update_atrribtes[:quick_report][:issue_attributes]
				@quick_report_update_atrribtes[:quick_report][:issue_attributes] = @quick_report.issue.check_change_responsible_person_event(@quick_report_update_atrribtes[:quick_report][:issue_attributes])
			end
		end
		it "update issue state" do
			@quick_report.should be_valid
			@quick_report.issue.should be_valid
			@quick_report.issue.resolve.should be_valid
			@quick_report.issue.state.should == "verifying_resolve"
			@quick_report.update_attributes(@quick_report_update_atrribtes[:quick_report])
			@quick_report.issue.state.should =="opened"

		end
	end
	describe "image CarrierWave" do
		let(:user_as_member) {FactoryGirl.build(:user_as_member)}
		before do
			original_filename = "issue_state.jpeg"
			@image = file = Tempfile.new('foo') 
			@tmp_image = Tempfile.new('foo')
			@tmp_image.binmode
			@tmp_image.write(IO::binread("#{Rails.root}/spec/issue_state.jpeg"))
			@tmp_image.rewind
			@uploaded_file = ActionDispatch::Http::UploadedFile.new(
					:tempfile => @tmp_image, 
					:filename => original_filename, 
					:original_filename => original_filename) 
			Tenant.current_id			= user_as_member.tenant.id
			k = 1.day.since.strftime("%Y-%m-%d")
			@quick_report_attribute 			= {
													quick_report: 
													{
														issue_attributes:
														{
															level: "高",
															desc: "有问题",
															deadline: "#{k}",
															images_attributes:{
																"0" => {
																 	image: @uploaded_file
																 }
															}
														}
													}
												   }
			@strong_quick_report_attribute 		= ActionController::Parameters.new(@quick_report_attribute)
		end
		after do
			Tenant.current_id = nil
		end
		it "should create image" do
			lambda do
				@qr = QuickReport.new_quick_report_and_issue(@quick_report_attribute[:quick_report],user_as_member)
				@qr.save
			end.should change(Image,:count).by(1)
			@qr.issue.images[0].should_not be_nil
		end
		it "should create image"  do
			user_permission=Permissions.permission_for(user_as_member)
			user_permission.permit_params! @strong_quick_report_attribute
			lambda do
				@qr = QuickReport.new_quick_report_and_issue(@strong_quick_report_attribute[:quick_report],user_as_member)
				@qr.save
			end.should change(Image,:count).by(1)
			@qr.issue.images[0].should_not be_nil
		end
	end
end
