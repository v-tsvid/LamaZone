FactoryGirl.define do
  factory :rating do
    rate { rand(1..10) }
    review { Faker::Lorem.sentences(rand(0..10)).join(' ') }
    book
    customer
  end
end
