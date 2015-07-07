require 'rails_helper'

RSpec.describe Address, type: :model do
  let(:address) { FactoryGirl.create :address }

  [:phone, :address1, :city, :zipcode].each do |item|
    it "is invalid without #{item}" do
      expect(address).to validate_presence_of item
    end
  end

  it "belongs to country" do
    expect(address).to belong_to :country
  end
end
