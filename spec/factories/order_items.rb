FactoryGirl.define do
  factory :order_item do
    price { rand(10.0..100.0) }
    quantity { rand(1..100) }
    book
    order
  end
end
