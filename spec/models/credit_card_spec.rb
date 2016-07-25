require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  let(:credit_card) { FactoryGirl.create :credit_card }


  it "belongs to customer" do
    expect(credit_card).to belong_to :customer
  end

  it "has many orders" do
    expect(credit_card).to have_many :orders
  end
end
