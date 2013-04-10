# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quick_report do
    tenant {FactoryGirl.create(:tenant)}

  	factory :quick_report_with_issue  do
  		after(:build) do |quick_report,evaluator|
  			FactoryGirl.create(:issue,issuable: quick_report)
  		end
  	end
  end
#  factory :quick_report_with_issue ,class: QuickReport do
#    tenant {FactoryGirl.create(:tenant)}
#  	after(:build) do |quick_report,evaluator|
#  		FactoryGirl.create(:issue,issuable: quick_report)
#  	end
#  end
end
