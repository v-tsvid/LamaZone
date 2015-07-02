require 'rails_helper'

RSpec.describe Address, type: :model do
  let(:address) { FactoryGirl.create :address }

  [:phone, :address1, :city, :zipcode].each do |item|
    it "is invalid without #{item}" do
      expect(FactoryGirl.build :address, "#{item}": nil).not_to be_valid
    end
  end

end
