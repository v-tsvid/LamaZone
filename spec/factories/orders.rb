FactoryGirl.define do
  factory :order do
    state { Order::STATE_LIST.sample }
    next_step { CheckoutForm::NEXT_STEPS.sample }
    shipping_method { Order::SHIPPING_METHOD_LIST.sample }
    shipping_price { rand(0.0..100.0) }
    subtotal { rand(0.0..100.0) }
    total_price { rand(0.0..100.0) }
    completed_date { Date.today.next_day }
    customer
    credit_card
    coupon
    created_at { DateTime.now }
    association :billing_address, factory: :address
    association :shipping_address, factory: :address

    after(:build) { |order| order.class.skip_callback(
        :validation, :before, :update_total_price) }

    factory :order_skip_state_to_default do
      after(:build) { |order| order.class.skip_callback(
        :create, :before, :state_to_default) }
    end

    factory :order_with_or_without_coupon do
      after(:create) do |order, evaluator|
        coupon = [true, false].sample ? FactoryGirl.create(:coupon) : nil
        order.coupon = coupon
        order.save
      end
    end

    factory :order_with_order_items do
      transient do
        order_items_count { rand(1..10) }
      end
      after(:create) do |order, evaluator|
        items = create_list(:order_item, evaluator.order_items_count, order: order)
        order.order_items << items
        order.save
      end
    end
  end
end
