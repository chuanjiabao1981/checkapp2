#encoding:utf-8

FactoryGirl.define do
  factory :issue do
    level "高"
    desc "MyText"
    reject_reason "MyRejectText"
    deadline 	{1.day.since.strftime("%Y-%m-%d")}
    responsible_person {FactoryGirl.build(:user_as_member,tenant:issuable.tenant)}
    issuable {FactoryGirl.build(:quick_report)}
    submitter {FactoryGirl.build(:user_as_member,tenant: issuable.tenant)}
    tenant {issuable.tenant}
    factory :issue_with_resolve do
        after(:create) do |issue|
            FactoryGirl.create(:resolve,tenant: issue.tenant,issue: issue)
            issue.commit_resolve
        end 
    end
  end

end
