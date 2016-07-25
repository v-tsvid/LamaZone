require 'rails_helper'

RSpec.describe Address, type: :model do
  let(:address) { FactoryGirl.create :address }

  [:firstname, 
   :lastname, 
   :phone, 
   :address1, 
   :city, 
   :zipcode, 
   :country_id].each do |item|
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

  it "is using #normalize_phone as a callback before save" do
    expect(address).to callback(:normalize_phone).before(:save)
  end

  context "#attributes_short" do
    subject { address.attributes_short }

    it "returns short list of attributes" do
      expect(subject).to eq({
        "phone"      => address.phone, 
        "address1"   => address.address1, 
        "address2"   => address.address2, 
        "city"       => address.city, 
        "zipcode"    => address.zipcode, 
        "country_id" => address.country_id, 
        "firstname"  => address.firstname, 
        "lastname"   => address.lastname})
    end
  end
  
  context "#normalize_phone" do
    it "normalizes phone" do
      norm_phone = Phony.normalize(address.phone)
      expect(Phony).to receive(:normalize!).with(address.phone).
        and_return(norm_phone)
      address.send(:normalize_phone)
    end
  end

  context "#country_code" do
    it "returns alpha2 code of country address belongs to" do
      expect(address.send(:country_code)).
        to eq Country.find(address.country_id).alpha2
    end
  end
end
