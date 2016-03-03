FactoryGirl.define do
  # sequence(:email) { |n| "customer#{n}@mail.com" }

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

    # reset_password_token { Faker::Lorem.characters(32) }
    # reset_password_sent_at { 
    #   Faker::Time.between(DateTime.now - 100, DateTime.now) }
    # remember_created_at { 
    #   Faker::Time.between(DateTime.now - 200, DateTime.now - 100) }
    # sign_in_count 0
    # current_sign_in_at { 
    #   Faker::Time.between(DateTime.now - 100, DateTime.now) }
    # last_sign_in_at { Faker::Time(DateTime.now) }
    # current_sign_in_ip { Faker::Internet.ip_v4_address }
    # last_sign_in_ip { Faker::Internet.ip_v4_address }

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
