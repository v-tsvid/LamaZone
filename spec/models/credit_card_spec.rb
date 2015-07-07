require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  let(:credit_card) { FactoryGirl.create :credit_card }

  [:number, :cvv, :firstname, :lastname, :expiration_month, :expiration_year].each do |item|
    it "is invalid without #{item}" do
      expect(credit_card).to validate_presence_of item
    end
  end

  it "belongs to customer" do
    expect(credit_card).to belong_to :customer
  end

  it "has many orders" do
    expect(credit_card).to have_many :orders
  end
end
