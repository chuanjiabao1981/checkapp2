# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :image do
    image "MyString"
    image_attachment nil
    tenant nil
  end
end
