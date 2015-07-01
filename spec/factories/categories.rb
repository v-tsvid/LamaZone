FactoryGirl.define do
  factory :category do
    title { Faker::Lorem.words(rand(1..3)).join(' ') }
  end

end
