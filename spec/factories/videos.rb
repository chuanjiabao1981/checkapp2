# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :video do
    video "MyString"
    video_attachment nil
    tenant nil
  end
end
