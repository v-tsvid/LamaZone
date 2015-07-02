FactoryGirl.define do
  factory :customer do
    email { Faker::Internet.free_email }
    password "password"
    password_confirmation "password"
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }

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
