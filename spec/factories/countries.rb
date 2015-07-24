FactoryGirl.define do
  factory :country do
    sequence(:name) { |n| ISO3166::Country.all[n][0] }
    sequence(:alpha2) { |n| ISO3166::Country.all[n][1] }
  end
end
