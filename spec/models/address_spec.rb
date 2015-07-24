require 'rails_helper'

RSpec.describe Address, type: :model do
  let(:address) { FactoryGirl.create :address }

  [:phone, :address1, :city, :zipcode].each do |item|
    it "is invalid without #{item}" do
      expect(address).to validate_presence_of item
    end
  end
  
  context "with phone validation" do

    it "is valid when phone is plausible" do
      expect(Phony.plausible?(address.phone)).to eq true
    end
  end

  it "belongs to country" do
    expect(address).to belong_to :country
  end

  context "#normalize_phone" do
    let(:abnorm_address) { FactoryGirl.create(
      :address_with_normalized_phone, phone: "380s930d1$23-456") }
      
    it "normalizes phone before saving" do
      expect(abnorm_address.phone).to eq Phony.normalize(abnorm_address.phone)
    end
  end

  context "#country_code" do
    it "returns alpha2 code of country address belongs to" do
      expect(address.send(:country_code)).
        to eq Country.find(address.country_id).alpha2
    end
  end
end
