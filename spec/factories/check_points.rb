# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :check_point do
    content "MyString"
    tenant nil
    template nil
  end
end
