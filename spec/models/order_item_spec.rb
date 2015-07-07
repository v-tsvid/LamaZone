require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  let(:order_item) { FactoryGirl.create :order_item }

  [:price, :quantity].each do |item|
    it "is invalid without #{item}" do
      expect(order_item).to validate_presence_of item
    end
  end

  [:book, :order].each do |item|
    it "belongs to #{item}" do
      expect(order_item).to belong_to item
    end
  end
end
