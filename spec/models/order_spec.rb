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

  context "#in_progress" do
    let(:books_in_progress) { FactoryGirl.create_list(:order, 3, state: 0, 
      created_at: DateTime.now, completed_date: Date.today.next_day) }

    it "returns books in progress" do
      expect(Order.in_progress).to match_array(books_in_progress)
    end

    [:books_processing, 
     :books_pending, 
     :books_shipping, 
     :books_completed, 
     :books_cancelled].map.with_index do |item, index|
      it "does not return #{item}" do
        item = FactoryGirl.create_list(:order, 3, state: index + 1, 
          created_at: DateTime.now, completed_date: Date.today.next_day)
        expect(Order.in_progress).not_to match_array(item)
      end
    end 
  end

  context "#state_to_default" do
    let(:order_with_state_to_default) { 
      FactoryGirl.create(:order_with_state_to_default, state: 2, 
        created_at: DateTime.now, completed_date: Date.today.next_day) }
    
    it "saves books with in_progress state" do
      expect(order_with_state_to_default.state).to eq 0
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
end
