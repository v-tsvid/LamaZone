FactoryGirl.define do
  factory :author do
    firstname { Faker::first_name }
    lastname { Faker::last_name }
    biography { Faker::Lorem.paragraphs(rand(3..5)).join('\n') }
  end
end
