# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :resolve do
    desc "MyText"
    tenant {FactoryGirl.build(:tenant)}
    submitter {FactoryGirl.build(:user_as_member,tenant: tenant)}
    issue {FactoryGirl.build(:issue,tenant: tenant)}
  end
end
