require 'rails_helper'

RSpec.describe Customer, type: :model do
  let(:customer) { FactoryGirl.create :customer }

  [:email, :password, :password_confirmation, :firstname, :lastname].each do |item|
    it "is invalid without #{item}" do
      expect(customer).to validate_presence_of item
    end
  end

  it "does not allow duplicate email" do
    expect(customer).to validate_uniqueness_of :email
  end

  [:orders, :ratings].each do |item|
    it "has many #{item}" do
      expect(customer).to have_many item
    end
  end

  context ".add_order" do
    it "adds new order" do
      expect(customer.add_order.new_record?).to be true
    end
  end

  context ".order_in_progress" do
    it "returns first order in progress" do
      orders = FactoryGirl.create_list(:order, 3, customer_id: customer.id, state: 0)
      expect(customer.order_in_progress).to eq orders.first
    end
  end
end
