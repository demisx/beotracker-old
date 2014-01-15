FactoryGirl.define do
  factory :user do
    first_name nil
    last_name nil
    email { Faker::Internet.email }
    password "test1234"
  end
end
