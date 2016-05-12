require 'rails_helper'

RSpec.describe CreditCardForm, type: :model do
  let(:credit_card) { FactoryGirl.create :credit_card }
  let(:credit_card_form) { CreditCardForm.new(credit_card) }
  subject { credit_card_form }

  [:firstname,
   :lastname,
   :number,
   :cvv,
   :expiration_month,
   :expiration_year,
   :customer_id].each do |item|
    it { is_expected.to respond_to item }
    it { is_expected.to validate_presence_of item }
  end

  it "is invalid when number is invalid" do
    expect(CreditCardValidator::Validator.valid?(credit_card.number)).to eq true
  end

  context "with cvv regex" do
    ["12", "12345", "1q2", "qwer", "12$4"].each do |item|
      it "is invalid when cvv is \"#{item}\"" do
        expect(subject).not_to allow_value(item).for(:cvv)
      end
    end
    
    ["123", "1234"].each do |item|
      it "is valid when cvv is \"#{item}\"" do
        expect(subject).to allow_value(item).for(:cvv)
      end
    end
  end

  
  context "with expiration_month regex" do
    ["1", "13", "20"].each do |item|
      it "is invalid when expiration_month is \"#{item}\"" do
        expect(subject).not_to allow_value(item).for(:expiration_month)
      end
    end

    ["01", "09", "10", "12"].each do |item|
      it "is valid when expiration_month is \"#{item}\"" do
        expect(subject).to allow_value(item).for(:expiration_month)
      end
    end
  end

  context "with expiration_year regex" do
    ["2014", "1234", "201x", "201", "20161", "1991", "2030"].each do |item|
      it "is invalid when expiration_year is \"#{item}\"" do
        expect(subject).not_to allow_value(item).for(:expiration_year)
      end
    end

    ["2015", "2016", "2029"].each do |item|
      it "is valid when expiration_year is \"#{item}\"" do
        expect(subject).to allow_value(item).for(:expiration_year)
      end
    end
  end

  it "is invalid when expiration_year is now and expiration_month was in the past" do
    if Date.today.strftime("%m") == "01"
      allow(Date).to receive(:today).and_return(Date.today.next_month) 
    end
    
    subject.expiration_month = Date.today.prev_month.strftime("%m")
    subject.expiration_year = Date.today.strftime("%Y")
    expect{ subject.valid? }.
      to change{ subject.errors.messages[:base] }.
      to contain_exactly(CreditCardForm::EXPIRED_MESSAGE)
  end

  it "is invalid when expiration_year was in the past" do
    subject.expiration_year = Date.today.prev_year.strftime("%Y")
    expect{ subject.valid? }.
      to change{ subject.errors.messages[:base] }.
      to contain_exactly(CreditCardForm::EXPIRED_MESSAGE)
  end
end