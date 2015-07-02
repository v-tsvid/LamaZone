require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  let(:credit_card) { FactoryGirl.create :credit_card }

  [:number, :cvv, :firstname, :lastname, :expiration_month, :expiration_year].each do |item|
    it "is invalid without #{item}" do
      expect(FactoryGirl.build :credit_card, "#{item}": nil).not_to be_valid
    end
  end
end
