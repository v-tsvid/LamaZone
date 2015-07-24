require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  let(:order_item) { FactoryGirl.create :order_item }

  [:price, :quantity].each do |item|
    it "is invalid without #{item}" do
      expect(order_item).to validate_presence_of item
    end
  end

  it "is valid only when price is numerical and greater than or equal to 0" do
    expect(order_item).to validate_numericality_of(:price).
      is_greater_than_or_equal_to 0
  end

  it "is valid only when quantity is integer and greater than or equal to 0" do
    expect(order_item).to validate_numericality_of(:quantity).only_integer.
      is_greater_than_or_equal_to 0
  end

  [:book, :order].each do |item|
    it "belongs to #{item}" do
      expect(order_item).to belong_to item
    end
  end
end
