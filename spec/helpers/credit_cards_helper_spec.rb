require 'rails_helper'

RSpec.describe CreditCardsHelper do

  # [:credit_card_errors?, [:errors, :attr_sym], "credit_card.#{attr_sym}"]
  # :method_name, :params, :key
  # {method: :credit_card_errors?, params: }

  context "#credit_card_errors?" do
    let(:attr_sym) { :number }
    let(:errors) { {"credit_card.#{attr_sym}" => 'not nil'} }
    
    subject { credit_card_errors?(errors, attr_sym) }

    it "is truthy if there's errors for attribute" do
      expect(subject).to be_truthy
    end
  end

  context "#card_number_errors?" do
    let(:errors) { {"credit_card.credit_card" => 'not nil'} }
    
    subject { card_number_errors?(errors) }

    it "is truthy if there's errors for attribute" do
      expect(subject).to be_truthy
    end
  end

  context "#card_date_errors?" do
    let(:errors) { {"base" => 'not nil'} }
    
    subject { card_date_errors?(errors) }

    it "is truthy if there's errors for attribute" do
      expect(subject).to be_truthy
    end
  end
end