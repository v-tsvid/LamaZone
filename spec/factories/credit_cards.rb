FactoryGirl.define do
  factory :credit_card do
    number { Faker::Business.credit_card_number }
    cvv { Faker::Number.number(3) }
    expiration_month { Time.now.month }
    expiration_year { Time.now.year }
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    customer
  end

end
