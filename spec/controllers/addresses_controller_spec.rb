require 'rails_helper'
require 'controllers/shared/shared_controller_specs'

RSpec.describe AddressesController, type: :controller do

  let(:valid_attributes) { FactoryGirl.attributes_for(:address).stringify_keys }
  let(:invalid_attributes) { 
    FactoryGirl.attributes_for(:address, phone: 'invalid').stringify_keys}
  let(:customer) { 
    FactoryGirl.create :customer, 
    billing_address: nil, 
    shipping_address: nil }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:customer]
    sign_in customer
    request.env["HTTP_REFERER"] = root_path
  end

  describe "POST #create" do
    context "with valid params" do  
      subject { post :create, { address: valid_attributes } }

      it_behaves_like "customer authentication"
      it_behaves_like "load and authorize resource"
      

      it "creates a new Address" do
        expect { subject }.to change(Address, :count).by(1)
      end

      it "assigns a newly created address as @address" do
        subject
        expect(assigns(:address)).to be_a(Address)
        expect(assigns(:address)).to be_persisted
      end

      it "redirects to current customer settings editing page" do
        subject
        expect(response).to redirect_to(
          edit_customer_registration_path(customer))
        expect(flash[:notice]).to eq 'Address was successfully created'
      end
    end

    context "with invalid params" do
      subject { post :create, { address: invalid_attributes } }

      it_behaves_like "customer authentication"
      it_behaves_like "load and authorize resource"

      it "assigns a newly created but unsaved address as @address" do
        subject
        expect(assigns(:address)).to be_a_new(Address)
      end

      it "redirects to :back" do
        subject
        expect(response).to redirect_to request.env["HTTP_REFERER"]
      end
    end
  end

  describe "PUT #update" do
    let(:address) { address = FactoryGirl.create :address }
    
    before do
      allow(Address).to receive(:find).and_return address
      customer.billing_address = address
    end

    context "with valid params" do  
      subject { put :update, {id: address.to_param, address: valid_attributes} }

      it_behaves_like "customer authentication"
      it_behaves_like "load and authorize resource"
      
      it "receives :update on @address" do
        expect(Address).to receive(:find).and_return(address)
        subject
      end

      it "updates the requested address" do
        subject
        expect(address.attributes).to include valid_attributes
      end

      it "assigns the requested address as @address" do
        subject
        expect(assigns(:address)).to eq(address)
      end

      it "redirects to current customer settings editing page" do
        subject
        expect(response).to redirect_to(
          edit_customer_registration_path(customer))
        expect(flash[:notice]).to eq 'Address was successfully updated'
      end
    end

    context "with invalid params" do
      subject { put :update, {id: address.to_param, address: invalid_attributes} }

      it_behaves_like "customer authentication"
      it_behaves_like "load and authorize resource"

      it "assigns the address as @address" do
        subject
        expect(assigns(:address)).to eq(address)
      end

      it "redirects to :back" do
        subject
        expect(response).to redirect_to request.env["HTTP_REFERER"]
      end
    end
  end
end
