FactoryGirl.define do
  factory :customer do
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"
    provider 'facebook'
    uid { Faker::Number.number(15) }
    association :billing_address, factory: :address
    association :shipping_address, factory: :address

    factory :customer_with_orders do
      transient do
        orders_count 5
      end
      after(:create) do |customer, evaluator|
        create_list(:order, evaluator.orders_count, customer: customer)
      end
    end

    factory :customer_with_ratings do
      transient do
        ratings_count 5
      end
      after(:create) do |customer, evaluator|
        create_list(:rating, evaluator.ratings_count, customer: customer)
      end
    end
  end
end
