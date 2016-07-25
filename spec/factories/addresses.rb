FactoryGirl.define do
  factory :address do
    sequence(:phone, 9000000) { |n| "38093#{n}"}
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    address1 { Faker::Address.street_address }
    address2 { Faker::Address.secondary_address }
    city { Faker::Address.city }
    zipcode { Faker::Address.zip_code }
    country_id { rand(1..250) }

    factory :address_skip_normalize_phone do
      after(:build) { |address| address.class.skip_callback(
        :save, :before, :normalize_phone) }
    end 
  end
end
