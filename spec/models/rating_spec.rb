require 'rails_helper'

RSpec.describe Rating, type: :model do
  let(:rating) { FactoryGirl.create :rating }

  it "is valid only when rate is integer from 1 to 10" do
    expect(rating).to validate_numericality_of(:rate).only_integer.
      is_greater_than(0).is_less_than(11)
  end

  [:customer, :book].each do |item|
    it "belongs to #{item}" do
      expect(rating).to belong_to item
    end
  end
end
