require 'rails_helper'

RSpec.describe AddressesController, type: :controller do

  let(:customer) { FactoryGirl.create :customer }
  let(:wrong_customer) { FactoryGirl.create :customer }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:customer]
    sign_in customer
  end

  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AddressesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  shared_examples "customer authentication" do
    it "receives authenticate_customer!" do
      expect(controller).to receive(:authenticate_customer!)
    end
  end

  # describe "GET #index" do

  #   it "assigns all addresses of current customer as @addresses" do
  #     addresses = FactoryGirl.create_list :address, 2, customer_id: customer.id
  #     wrong_address = FactoryGirl.create :address, customer_id: wrong_customer.id
  #     get :index, { customer_id: customer.id }
  #     expect(assigns(:addresses)).to eq(addresses)
  #   end
    
  #   after { get :index, { customer_id: customer.id } }

  #   it_behaves_like 'customer authentication'
  # end

  describe "GET #show" do
    it "assigns the requested address as @address" do
      address = Address.create! valid_attributes
      get :show, {:id => address.to_param}, valid_session
      expect(assigns(:address)).to eq(address)
    end
  end

  describe "GET #new" do
    it "assigns a new address as @address" do
      get :new, {customer_id: customer.id}, valid_session
      expect(assigns(:address)).to be_a_new(Address)
    end
  end

  describe "GET #edit" do
    it "assigns the requested address as @address" do
      address = Address.create! valid_attributes
      get :edit, {:id => address.to_param}, valid_session
      expect(assigns(:address)).to eq(address)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Address" do
        expect {
          post :create, {:address => valid_attributes}, valid_session
        }.to change(Address, :count).by(1)
      end

      it "assigns a newly created address as @address" do
        post :create, {:address => valid_attributes}, valid_session
        expect(assigns(:address)).to be_a(Address)
        expect(assigns(:address)).to be_persisted
      end

      it "redirects to the created address" do
        post :create, {:address => valid_attributes}, valid_session
        expect(response).to redirect_to(Address.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved address as @address" do
        post :create, {:address => invalid_attributes}, valid_session
        expect(assigns(:address)).to be_a_new(Address)
      end

      it "re-renders the 'new' template" do
        post :create, {:address => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested address" do
        address = Address.create! valid_attributes
        put :update, {:id => address.to_param, :address => new_attributes}, valid_session
        address.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested address as @address" do
        address = Address.create! valid_attributes
        put :update, {:id => address.to_param, :address => valid_attributes}, valid_session
        expect(assigns(:address)).to eq(address)
      end

      it "redirects to the address" do
        address = Address.create! valid_attributes
        put :update, {:id => address.to_param, :address => valid_attributes}, valid_session
        expect(response).to redirect_to(address)
      end
    end

    context "with invalid params" do
      it "assigns the address as @address" do
        address = Address.create! valid_attributes
        put :update, {:id => address.to_param, :address => invalid_attributes}, valid_session
        expect(assigns(:address)).to eq(address)
      end

      it "re-renders the 'edit' template" do
        address = Address.create! valid_attributes
        put :update, {:id => address.to_param, :address => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested address" do
      address = Address.create! valid_attributes
      expect {
        delete :destroy, {:id => address.to_param}, valid_session
      }.to change(Address, :count).by(-1)
    end

    it "redirects to the addresses list" do
      address = Address.create! valid_attributes
      delete :destroy, {:id => address.to_param}, valid_session
      expect(response).to redirect_to(addresses_url)
    end
  end

end
