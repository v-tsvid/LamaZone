FactoryGirl.define do
  sequence(:name) { |n| "Country#{n}" }

  factory :country do
    name
  end
end
