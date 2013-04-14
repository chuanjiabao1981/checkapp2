# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :quick_report do
    tenant {FactoryGirl.create(:tenant)}


  	factory :quick_report_with_issue  do
      ignore do
        submitter nil
      end
      tenant do 
        if not submitter.nil?
          submitter.tenant
        else
          FactoryGirl.create(:tenant)
        end
      end
  		after(:build) do |quick_report,evaluator|
  			if evaluator.submitter.nil? 
  				FactoryGirl.create(:issue,issuable: quick_report,tenant: quick_report.tenant)
  			else
  				FactoryGirl.create(:issue,issuable: quick_report,submitter: evaluator.submitter,tenant: evaluator.submitter.tenant)
  			end
  		end
  	end

    factory :quick_report_with_issue_and_resolve do
      ignore do
        issue_submitter nil
        responsible_person nil
      end
      tenant { issue_submitter.tenant }
      after(:build) do | quick_report,evaluator| 
        FactoryGirl.create(:issue_with_resolve,
                           issuable:    quick_report,
                           submitter:   evaluator.issue_submitter,
                           responsible_person: evaluator.responsible_person
                           )
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
