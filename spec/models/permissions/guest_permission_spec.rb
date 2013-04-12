require "spec_helper"

describe Permissions::GuestPermission do
	describe "allow session"  do
		it "not allows users" do
			should_not allow(:users,:index)
			should_not allow(:users,:create)
		end
		it "not allows tenant" do
			should_not allow(:tenant,:index)
			should_not allow(:tenant,:create)
		end
		it "allows sessions" do
			should allow(:sessions,:new)
			should allow(:sessions,:create)
			should allow(:sessions,:destroy)
		end
		it "allows home" do
			should allow(:main,:home)
		end

		it "not allows issue" do
			should_not allow(:issues,:index)
			should_not allow(:issues,:create)
		end
	end
end
