
require 'spec_helper'

describe Issue do
	#let(:quick_report) {FactoryGirl.build(:quick_report)}
	subject {@issue}
	before do
		@issue = FactoryGirl.create(:issue)
	end	
	describe "Facotry Valid"  do
		it "should valid" do
			should be_valid
			should respond_to(:videos)
			should respond_to(:images)
			should respond_to(:resolve)
			should respond_to(:finder)
			should respond_to(:responsible_person)
			should respond_to(:deadline)
			should respond_to(:issuable)
			should respond_to(:desc)

		end
	end
	describe "Destroy Issue" do
		before do 
			@issue = FactoryGirl.create(:issue_with_resolve)
			@issue.should be_valid
		end
		it  "destroy Resolve"do
			expect {@issue.destroy}.to change {Resolve.count}.by(-1)
		end
	end
	describe "Factory Not Valid" do
		before do 
			@issue.should be_valid
		end
		describe "DeadLine not valid"  do
			before do
				@issue.deadline = 1.day.ago.strftime("%Y-%m-%d")
			end
			it {should_not be_valid}
		end
		describe "State not valid"  do
			before do
				@issue.state ="111"
			end
			it { should_not be_valid }
		end
		describe "quick_report is nil" do
			before do
				@issue.issuable = nil
			end
			it {should_not be_valid }
		end
		describe "tenant is nil" do
			before do
				@issue.tenant = nil
			end
			it {should_not be_valid}
		end
		describe "finder is nil" do
			before do
				@issue.finder = nil
			end
			it {should_not be_valid}
		end
	end
	describe "State Machine" do
		describe "opened"  do
			it {should be_opened}
			it {should be_can_change_responsible_person}
			it {should be_can_commit_resolve}
			it "no responsible_person is valid" do
				@issue.message_for_responsible_person.should == "opened"
				@issue.responsible_person = nil
				@issue.should be_valid
			end
		end
		describe "verifying_resolve"  do
			before do
				@issue.message_for_finder.should be_nil
				@issue.commit_resolve!
				@issue.message_for_finder.should == "verifying_resolve"
				@issue.should be_valid
			end
			it {should be_verifying_resolve}
			it {should be_can_change_responsible_person}
			it {should be_can_close}
			it {should be_can_reject_resolve}
			it "should to opened" do
				@issue.change_responsible_person!
				@issue.should be_opened
			end
			it "should to resolve_denied" do
				@issue.reject_resolve!
				@issue.should be_resolve_denied
			end
			it "should to closed" do
				@issue.close!
				@issue.should be_closed
			end
			it "no responsible_person is not valid" do
				@issue.responsible_person = nil
				@issue.should_not be_valid
			end
		end
		describe "closed"   do
			before do
				@issue.commit_resolve!
				@issue.message_for_responsible_person.should == "opened"
				@issue.close!
				@issue.message_for_responsible_person.should == "closed"
				@issue.should be_valid
			end

			it {should be_closed}
			it {should be_can_reject_resolve}
			it "should to resolve_denied" do
				@issue.reject_resolve
				@issue.should be_resolve_denied
			end
			it "no responsible_person is not valid" do
				@issue.responsible_person = nil
				@issue.should_not be_valid
			end
		end
		describe "resolve_denied"  do
			before do
				@issue.commit_resolve!
				@issue.message_for_responsible_person.should == "opened"
				@issue.reject_resolve!
				@issue.message_for_responsible_person.should == "resolve_denied"
				@issue.should be_valid
			end
			it {should be_resolve_denied}
			it {should be_can_commit_resolve}
			it {should be_can_change_responsible_person}
			it "should to opened"   do
				@issue.change_responsible_person!
				@issue.should be_opened
			end
			it "no responsible_person is not valid" do
				@issue.responsible_person = nil
				@issue.should_not be_valid
			end
			describe "change responsible_person "   do
				before do
					@issue =FactoryGirl.create(:issue_with_resolve)
				end
				it "should destroy the resolve" do
					expect {@issue.change_responsible_person!}.to change{Resolve.count}.by(-1)
				end
			end
		end
	end

end
