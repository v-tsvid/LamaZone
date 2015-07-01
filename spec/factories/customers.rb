FactoryGirl.define do
  factory :customer do
    email { Faker::Internet.free_email }
    password "password"
    password_confirmation "password"
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
  end
end
