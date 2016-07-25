shared_examples 'address form specs' do
  let(:address) { FactoryGirl.create :address }
  let(:address_form) { BillingAddressForm.new(address) }
  subject { address_form }

  before do
    allow_any_instance_of(Address).to receive(:normalize_phone)
  end

  [:firstname,
   :lastname,
   :address1,
   :address2,
   :phone,
   :city,
   :zipcode,
   :country_id,
   :billing_address_for_id,
   :shipping_address_for_id].each do |item|
    it { is_expected.to respond_to item }
  end  

  [:firstname,
   :lastname,
   :address1,
   :phone,
   :city,
   :zipcode,
   :country_id].each do |item|
    it { is_expected.to validate_presence_of item }
  end

  context "with phone validation" do
    it "is valid when phone is plausible" do
      expect(Phony.plausible?(subject.phone)).to eq true
    end
  end

  it "is using #normalize_phone as a callback before save" do
    expect(subject).to receive(:normalize_phone)
    subject.save
  end
  
  context "#normalize_phone" do
    it "normalizes phone" do
      norm_phone = Phony.normalize(subject.phone)
      expect(Phony).to receive(:normalize!).with(subject.phone).
        and_return(norm_phone)
      subject.send(:normalize_phone)
    end
  end

  context "#country_code" do
    it "returns alpha2 code of country address belongs to" do
      expect(subject.send(:country_code)).
        to eq Country.find(address.country_id).alpha2
    end
  end
end