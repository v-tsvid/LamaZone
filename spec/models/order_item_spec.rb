require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  let(:order_item) { FactoryGirl.create :order_item }

  [:price, :quantity].each do |item|
    it "is invalid without #{item}" do
      expect(FactoryGirl.build :order_item, "#{item}": nil).not_to be_valid
    end
  end
end
