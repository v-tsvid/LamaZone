require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  let(:credit_card) { FactoryGirl.create :credit_card }

  [:number, :cvv, :firstname, :lastname, 
    :expiration_month, :expiration_year].each do |item|
    it "is invalid without #{item}" do
      expect(credit_card).to validate_presence_of item
    end
  end

  it "is invalid when number is invalid" do
    expect(CreditCardValidator::Validator.valid?(credit_card.number)).to eq true
  end

  context "with cvv regex" do
    ["12", "12345", "1q2", "qwer", "12$4"].each do |item|
      it "is invalid when cvv is \"#{item}\"" do
        expect(credit_card).not_to allow_value(item).for(:cvv)
      end
    end
    
    ["123", "1234"].each do |item|
      it "is valid when cvv is \"#{item}\"" do
        expect(credit_card).to allow_value(item).for(:cvv)
      end
    end
  end

  
  context "with expiration_month regex" do
    ["1", "13", "20"].each do |item|
      it "is invalid when expiration_month is \"#{item}\"" do
        expect(credit_card).not_to allow_value(item).for(:expiration_month)
      end
    end

    ["01", "09", "10", "12"].each do |item|
      it "is valid when expiration_month is \"#{item}\"" do
        expect(credit_card).to allow_value(item).for(:expiration_month)
      end
    end
  end

  context "with expiration_year regex" do
    ["2014", "1234", "201x", "201", "20161", "1991", "2030"].each do |item|
      it "is invalid when expiration_year is \"#{item}\"" do
        expect(credit_card).not_to allow_value(item).for(:expiration_year)
      end
    end

    ["2015", "2016", "2029"].each do |item|
      it "is valid when expiration_year is \"#{item}\"" do
        expect(credit_card).to allow_value(item).for(:expiration_year)
      end
    end
  end

  it "is invalid when exp_year is now and expiration_month was in the past" do
    credit_card.expiration_month = Date.today.prev_month.strftime("%m")
    credit_card.expiration_year = Date.today.strftime("%Y")
    expect{ credit_card.valid? }.
      to change{ credit_card.errors.messages[:base] }.
      to contain_exactly(CreditCard::EXPIRED_MESSAGE)
  end

  it "is invalid when expiration_year was in the past" do
    credit_card.expiration_year = Date.today.prev_year.strftime("%Y")
    expect{ credit_card.valid? }.
      to change{ credit_card.errors.messages[:base] }.
      to contain_exactly(CreditCard::EXPIRED_MESSAGE)
  end

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
