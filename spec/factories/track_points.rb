# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :track_point do
    lat 1.5
    lng 1.5
    radius 1.5
    coortype "MyString"
    tenant nil
    user nil
    generated_time_of_client_version "2013-04-30 15:39:59"
    generated_time_of_server_verion "2013-04-30 15:39:59"
  end
end
