FactoryGirl.define do
  factory :order do
    state { rand(0..3) }
    total_price { rand(10.0..1000.0) }
    completed_date { Date.tomorrow }
    customer
    credit_card
    association :billing_address, factory: :address
    association :shipping_address, factory: :address

    factory :order_with_order_items do
      transient do
        order_items_count 5
      end
      after(:create) do |order, evaluator|
        create_list(:order_item, evaluator.order_items_count, order: order)
      end
    end
  end

end
