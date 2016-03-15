require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order) { FactoryGirl.create :order, created_at: DateTime.now,
    completed_date: Date.today.next_day }

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

  it "is valid only when total_price is numerical and greater than 0" do
    expect(order).to validate_numericality_of(:total_price).
      is_greater_than 0
  end
  
  it "is invalid when state is mot included in permitted states list" do
    expect(order).to validate_inclusion_of(:state).in_array(Order::STATE_LIST)
  end

  it "is invalid when completed_date is invalid" do
    order.completed_date = "incorrect date"
    expect{ order.valid? }.to change{ order.errors.messages[:completed_date] }
  end

  it "is invalid when completed_date is before order creation date" do
    order.completed_date = Date.today.prev_day
    expect{ order.valid? }.
      to change{ order.errors.messages[:completed_date] }.
      to contain_exactly(Order::DATE_COMPLETE_BEFORE_CREATE_MESSAGE)
  end

  it "has many order_items" do
    expect(order).to have_many :order_items
  end

  context "#custom_label_method" do
    it "returns string with id" do
      expect(order.send(:custom_label_method)).
        to eq "#{order.id}"
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

  context "#add_book" do
    let(:books) { FactoryGirl.create_list(:book, 2) }
    
    before { order.send(:add_book, books[0]) }

    it "adds new book as order_item" do
      order.send(:add_book, books[1])
      expect(order.order_items.size).to eq 2
    end

    it "does not add new book if it was added early" do
      order.send(:add_book, books[0])
      expect(order.order_items.size).to eq 1
    end

    it "increments book quantity if book was added early" do
      expect{ order.send(:add_book, books[0]) }.to change{ 
        OrderItem.find_by(order_id: order.id, book_id: books[0].id).quantity 
        }.from(1).to(2)
    end
  end

  # context "before saving the order" do
    
  #   let(:unsaved_order) { FactoryGirl.build :order }
    
  #   it "update total_price for the order" do
  #     expect(unsaved_order).to receive(:update_total_price)
  #     unsaved_order.save
  #   end
  # end

  context "#update_total_price" do

    let(:order) { FactoryGirl.create :order }

    it "sets total_price of the order equal to sum of all the order_items" do
      order_items = FactoryGirl.create_list :order_item, 2, order: order
      order.order_items << order_items
      

      ttl_prc = order_items.collect { |item| (item.quantity * item.price) }.sum

      expect{order.update_total_price}.to change{order.total_price}.to ttl_prc
    end
  end
end
