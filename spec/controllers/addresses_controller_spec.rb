require 'rails_helper'
require 'shared/controllers/shared_controllers_specs'
require 'shared/controllers/shared_addresses_controller_specs'

RSpec.describe AddressesController, type: :controller do

  let(:customer) { FactoryGirl.create :customer, billing_address: nil, 
    shipping_address: nil }
  let(:address) { FactoryGirl.build_stubbed :address }
  let(:valid_attributes) { FactoryGirl.attributes_for(:address).stringify_keys }
  
  before do
    @request.env["devise.mapping"] = Devise.mappings[:customer]
    sign_in customer
    request.env["HTTP_REFERER"] = edit_customer_registration_path(customer)
  end

  describe "POST #create" do

    subject { post :create, { address: valid_attributes } }

    it 'receives :save on @address' do
      allow(Address).to receive(:new).and_return address
      expect(address).to receive :save
      subject
    end

    
    it_behaves_like "load and authorize resource", :address
    it_behaves_like 'check abilities', :create, Address

    context "when @address was saved" do  
      subject { post :create, { address: valid_attributes } }

      before do 
        allow_any_instance_of(Address).to receive(:save).and_return true
      end

      it "redirects to current customer settings editing page" do
        subject
        expect(response).to redirect_to(
          edit_customer_registration_path(customer))
      end

      it_behaves_like 'flash setting', :notice, t("controllers.address_created")
    end

    context "when @address was NOT saved" do  
      subject { post :create, { address: valid_attributes } }

      before do 
        allow_any_instance_of(Address).to receive(:save).and_return false
      end

      it_behaves_like 'redirecting to :back'
      it_behaves_like 'setting alert within address errors'
    end
  end

  describe "PUT #update" do
    let(:address) { address = FactoryGirl.create :address }
    subject { put :update, {id: address.to_param, address: valid_attributes} }

    it 'receives :update on @address' do
      allow(Address).to receive(:find).and_return address
      expect(address).to receive(:update).with(stringify_hash valid_attributes)
      subject
    end
    
    it_behaves_like "customer authentication"
    it_behaves_like "load and authorize resource", :address
    it_behaves_like 'check abilities', :update, Address
    
    before do
      customer.billing_address = address
    end

    context 'when @address was updated' do
      it "redirects to current customer settings editing page" do
        subject
        expect(response).to redirect_to(
          edit_customer_registration_path customer)
      end

      it_behaves_like 'flash setting', :notice, t("controllers.address_updated")
    end

    context 'when @address was NOT updated' do
      before do 
        allow_any_instance_of(Address).to receive(:update).and_return false
      end

      it_behaves_like 'redirecting to :back'
      it_behaves_like 'setting alert within address errors'
    end
  end
end
