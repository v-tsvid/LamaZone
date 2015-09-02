FactoryGirl.define do
  factory :credit_card do
    number "5168 7423 2791 0638"
    cvv { Faker::Number.number(3) }
    expiration_month { Date.today.next_month.strftime("%m") }
    expiration_year { Date.today.next_year.strftime("%Y") }
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    customer

    factory :credit_card_with_orders do
      transient do
        orders_count { rand(1..10) }
      end
      after(:create) do |credit_card, evaluator|
        create_list(:order, evaluator.orders_count, credit_card: credit_card)
      end
    end
  end
end
