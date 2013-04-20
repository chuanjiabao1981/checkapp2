# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :organization do
    name "MyString"
    address "MyString"
    tenant nil
    manager nil
  end
end
