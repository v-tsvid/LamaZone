require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  let(:credit_card) { FactoryGirl.create :credit_card }


  it "belongs to customer" do
    expect(credit_card).to belong_to :customer
  end

  it "has many orders" do
    expect(credit_card).to have_many :orders
  end

  context "#custom_label_method" do
    it "returns string with number" do
      expect(credit_card.send(:custom_label_method)).
        to eq "#{credit_card.number}"
    end
  end
end
