# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :template_report do
    template nil
    submitter nil
    tenant nil
  end
end
