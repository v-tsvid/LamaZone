require 'rails_helper'

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
end
