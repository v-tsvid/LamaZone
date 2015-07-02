FactoryGirl.define do
  factory :credit_card do
    number { Faker::Business.credit_card_number }
    cvv { Faker::Number.number(3) }
    expiration_month { Time.now.month }
    expiration_year { Time.now.year }
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    customer

    factory :credit_card_with_orders do
      transient do
        orders_count 5
      end
      after(:create) do |credit_card, evaluator|
        create_list(:order, evaluator.orders_count, credit_card: credit_card)
      end
    end
  end
end
