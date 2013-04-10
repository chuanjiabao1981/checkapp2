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
end
