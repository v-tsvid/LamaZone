require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:order) { FactoryGirl.create :order }

  [:total_price, :completed_date, :state].each do |item|
    it "is invalid without #{item}" do
      expect(FactoryGirl.build :order, "#{item}": nil).not_to be_valid
    end
  end
end
