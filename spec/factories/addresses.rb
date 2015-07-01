FactoryGirl.define do
  factory :address do
    phone { Faker::PhoneNumber.cell_phone }
    address1 { Faker::Address.street_address }
    address2 { Faker::Address.secondary_address }
    city { Faker::Address.city }
    zipcode { Faker::Address.zip_code }
    country
  end
end
