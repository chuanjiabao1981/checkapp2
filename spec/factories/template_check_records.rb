# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :template_check_record do
    template_report nil
    check_point nil
    submitter nil
    tenant nil
    state "MyString"
    desc "MyText"
    location nil
  end
end
