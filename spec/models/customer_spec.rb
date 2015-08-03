require 'rails_helper'

RSpec.describe Customer, type: :model do
  let(:customer) { FactoryGirl.create :customer }

  [:password, :password_confirmation].each do |item|
    it "responds to #{item}" do
      expect(customer).to respond_to(item)
    end
  end

  [:email, 
   :firstname, 
   :lastname].each do |item|
    it "is invalid without #{item}" do
      expect(customer).to validate_presence_of item
    end
  end

  it "does not allow case insensitive duplicating email" do
    expect(customer).to validate_uniqueness_of(:email).case_insensitive
  end

  # it "does not allow password contains less than 6 chars" do
  #   expect(customer).to validate_length_of(:password).is_at_least 6
  # end

  # it "requires password confirmation" do
  #   expect(customer).to validate_confirmation_of(:password)
  # end

  # it "is invalid when password does not match confirmation" do
  #   customer.password_confirmation = "mismatch"
  #   expect(customer).not_to be_valid
  # end

  [:orders, :ratings].each do |item|
    it "has many #{item}" do
      expect(customer).to have_many item
    end
  end

  context "#add_order" do
    it "adds new order" do
      expect(customer.send(:add_order).new_record?).to be true
    end
  end

  context "#order_in_progress" do
    it "returns first order in progress" do
      orders = FactoryGirl.create_list(:order, 3, customer_id: customer.id, state: 0)
      expect(customer.send(:order_in_progress)).to eq orders.first
    end
  end
end
