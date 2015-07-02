require 'rails_helper'

RSpec.describe Customer, type: :model do
  let(:customer) { FactoryGirl.create :customer }

  [:email, :password, :password_confirmation, :firstname, :lastname].each do |item|
    it "is invalid without #{item}" do
      expect(FactoryGirl.build :customer, "#{item}": nil).not_to be_valid
    end
  end

  it "does not allow duplicate email" do
    expect(FactoryGirl.build :customer, email: customer.email).not_to be_valid
  end
end
