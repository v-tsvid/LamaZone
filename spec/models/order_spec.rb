require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order) { FactoryGirl.create :order }

  [:total_price, :completed_date, :state].each do |item|
    it "is invalid without #{item}" do
      expect(order).to validate_presence_of item
    end
  end

  [:customer, :credit_card, :billing_address, :shipping_address].each do |item|
    it "belongs to #{item}" do
      expect(order).to belong_to item
    end
  end

  it "has many order_items" do
    expect(order).to have_many :order_items
  end

  context ".in_progress" do
    let(:orders_in_progress) { FactoryGirl.create_list(:order, 3, state: 0) }

    it "returns orders in progress" do
      expect(Order.in_progress).to match_array(orders_in_progress)
    end

    [:orders_processing, 
     :orders_pending, 
     :orders_shipping, 
     :orders_completed, 
     :orders_cancelled].map.with_index do |item, index|
      it "does not return #{item}" do
        item = FactoryGirl.create_list(:order, 3, state: index + 1)
        expect(Order.in_progress).not_to match_array(item)
      end
    end 
  end

  context ".state_to_default" do
    let(:order_with_state_to_default) { FactoryGirl.create(:order_with_state_to_default, state: 2) }
    
    it "saves orders with in_progress state" do
      expect(order_with_state_to_default.state).to eq 0
    end
  end

  context ".add_book" do
    before do
      FactoryGirl.create(:book, id: 1)
      FactoryGirl.create(:book, id: 2)
      order.add_book(1)
    end

    it "adds new book as order_item" do
      order.add_book(2)
      expect(order.order_items.size).to eq 2
    end

    it "does not add new book if it was added early" do
      order.add_book(1)
      expect(order.order_items.size).to eq 1
    end

    it "increments book quantity if book was added early" do
      expect{ order.add_book(1) }.to change{ 
        OrderItem.where(order_id: order.id, book_id: 1).pluck(:quantity) }.from([1]).to([2])
    end
  end
end
