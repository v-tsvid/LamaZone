require 'rails_helper'
require 'shared/models/shared_models_specs'

RSpec.describe Order, type: :model do
  let(:order) { FactoryGirl.create :order, created_at: DateTime.now,
    completed_date: Date.today.next_day }


  [:customer, :credit_card, :billing_address, :shipping_address].each do |item|
    it "belongs to #{item}" do
      expect(order).to belong_to item
    end
  end

  it "has many order_items" do
    expect(order).to have_many :order_items
  end

  context ".create_customers_order" do
    let(:customer) { FactoryGirl.create :customer }
    
    context "if customer passed is not nil" do
      subject { Order.create_customers_order(customer) }

      it "creates for customer order with state 'in_progress" do
        expect(Order).to receive(:create).with(
          customer: customer, state: 'in_progress')
        subject
      end
    end

    context "if customer passed is nil" do
      subject { Order.create_customers_order(nil) }

      it { is_expected.to eq nil }
    end
  end

  it_behaves_like 'state_enum testing', :order

  context "#custom_label_method" do
    it "returns decorated number" do
      expect(order.send(:custom_label_method)).
        to eq order.decorate.number
    end
  end

  context "#in_progress" do
    let(:orders_in_progress) { FactoryGirl.create_list(
      :order, 3, state: 'in_progress', 
      created_at: DateTime.now, completed_date: Date.today.next_day) }

    it "returns in_progress orders" do
      expect(Order.in_progress).to match_array(orders_in_progress)
    end

    Order::STATE_LIST[1..4].map do |item|
      it "does not return orders #{item}" do
        item = FactoryGirl.create_list(:order, 3, state: item, 
          created_at: DateTime.now, completed_date: Date.today.next_day)
        expect(Order.in_progress).not_to match_array(item)
      end
    end 
  end

  context "#prepare_for_checkout" do
    before do
      Coupon.create(code: '123', discount: 10)
    end

    it "updates order with coupon: nil if coupon was not found" do
      expect(order).to receive(:update).with(
        coupon: nil, next_step: order.next_step)
      order.prepare_for_checkout('invalid coupon code')
    end

    it "updates order with coupon if it was found" do
      expect(order).to receive(:update).with(
        coupon: Coupon.first, next_step: order.next_step)
      order.prepare_for_checkout(Coupon.first.code)
    end

    it "updates order with next_step: 'address' if order next_step is nil" do
      allow(order).to receive(:next_step).and_return nil
      expect(order).to receive(:update).with(
        coupon: Coupon.first, next_step: 'address')
      order.prepare_for_checkout(Coupon.first.code)
    end

    it "updates order current next_step if it is not nil" do
      expect(order).to receive(:update).with(
        coupon: Coupon.first, next_step: order.next_step)
      order.prepare_for_checkout(Coupon.first.code)
    end
  end
end
