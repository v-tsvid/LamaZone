require 'rails_helper'

RSpec.describe Rating, type: :model do
  let(:rating) { FactoryGirl.create :rating }

  [:customer, :book].each do |item|
    it "belongs to #{item}" do
      expect(rating).to belong_to item
    end
  end
end
