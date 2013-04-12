# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :resolve do
    desc "MyText"
    tenant {FactoryGirl.build(:tenant)}
    submitter {issue.responsible_person}
    issue {FactoryGirl.build(:issue,tenant: tenant)}
  end

  factory :resolve_with_responsible_person, parent: :resolve do
  	desc "MyText"
  	tenant {FactoryGirl.build(:tenant)}
  	submitter {FactoryGirl.build(:user_as_member,tenant: tenant)}
  	issue {FactoryGirl.build(:issue,tenant: tenant,responsible_person: submitter)}
  end
end
