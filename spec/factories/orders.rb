FactoryGirl.define do
  factory :order do
    state { rand(0..5) }
    total_price { rand(10.0..1000.0) }
    completed_date { Date.today.next_day }
    customer
    credit_card
    created_at { DateTime.now }
    association :billing_address, factory: :address
    association :shipping_address, factory: :address

    after(:build) { |order| order.class.skip_callback(:create, :before, :state_to_default) }

    factory :order_with_state_to_default do
      after(:create) { |order| order.send(:state_to_default) }
    end

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
