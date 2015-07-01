FactoryGirl.define do
  factory :order do
    state { rand(0..3) }
    total_price { rand(10.0..1000.0) }
    completed_date { Date.tomorrow }
    customer
    credit_card
    association :billing_address, factory: :address
    association :shipping_address, factory: :address
  end

end
