require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order) { FactoryGirl.create :order, created_at: DateTime.now,
    completed_date: Date.today.next_day }

  [:total_price, :state].each do |item|
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
      is_greater_than(0)
  end
  
  it "is invalid when state is not included in permitted states list" do
    expect(order).to validate_inclusion_of(:state).in_array(Order::STATE_LIST)
  end

  it "is invalid when completed_date is invalid" #do
  #   order.completed_date = "incorrect date"
  #   expect{ order.valid? }.to change{ order.errors.messages[:completed_date] }
  # end


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

  context "before saving the order" do
    
    let(:unsaved_order) { FactoryGirl.create :order_with_order_items }
    
    it "update total_price for the order" #do
    #   expect(unsaved_order).to receive(:update_total_price)

    #   unsaved_order.save!
    # end
  end

  context "#update_total_price" do

    let(:order) { FactoryGirl.build :order }

    it "sets total_price of the order equal to sum of all the order_items" do
      order_items = FactoryGirl.create_list :order_item, 2, order: order
      order.order_items << order_items
      

      ttl_prc = order_items[0].price * order_items[0].quantity + order_items[1].price * order_items[1].quantity


      expect{order.send(:update_total_price)}.to change{order.total_price}.to ttl_prc
    end
  end
end
