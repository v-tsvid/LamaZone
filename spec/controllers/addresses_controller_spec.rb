require 'rails_helper'

RSpec.describe AddressesController, type: :controller do

  # let(:customer) { FactoryGirl.create :customer }
  # let(:wrong_customer) { FactoryGirl.create :customer }

  # before do
  #   @request.env["devise.mapping"] = Devise.mappings[:customer]
  #   sign_in customer
  # end

  # let(:valid_attributes) {
  #   skip("Add a hash of attributes valid for your model")
  # }

  # let(:invalid_attributes) {
  #   skip("Add a hash of attributes invalid for your model")
  # }

  # # This should return the minimal set of values that should be in the session
  # # in order to pass any filters (e.g. authentication) defined in
  # # AddressesController. Be sure to keep this updated too.
  # let(:valid_session) { {} }

  # shared_examples "customer authentication" do
  #   it "receives authenticate_customer!" do
  #     expect(controller).to receive(:authenticate_customer!)
  #   end
  # end

  # describe "POST #create" do
  #   context "with valid params" do
  #     it "creates a new Address" do
  #       expect {
  #         post :create, {:address => valid_attributes}, valid_session
  #       }.to change(Address, :count).by(1)
  #     end

  #     it "assigns a newly created address as @address" do
  #       post :create, {:address => valid_attributes}, valid_session
  #       expect(assigns(:address)).to be_a(Address)
  #       expect(assigns(:address)).to be_persisted
  #     end

  #     it "redirects to the created address" do
  #       post :create, {:address => valid_attributes}, valid_session
  #       expect(response).to redirect_to(Address.last)
  #     end
  #   end

  #   context "with invalid params" do
  #     it "assigns a newly created but unsaved address as @address" do
  #       post :create, {:address => invalid_attributes}, valid_session
  #       expect(assigns(:address)).to be_a_new(Address)
  #     end

  #     it "re-renders the 'new' template" do
  #       post :create, {:address => invalid_attributes}, valid_session
  #       expect(response).to render_template("new")
  #     end
  #   end
  # end

  # describe "PUT #update" do
  #   context "with valid params" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }

  #     it "updates the requested address" do
  #       address = Address.create! valid_attributes
  #       put :update, {:id => address.to_param, :address => new_attributes}, valid_session
  #       address.reload
  #       skip("Add assertions for updated state")
  #     end

  #     it "assigns the requested address as @address" do
  #       address = Address.create! valid_attributes
  #       put :update, {:id => address.to_param, :address => valid_attributes}, valid_session
  #       expect(assigns(:address)).to eq(address)
  #     end

  #     it "redirects to the address" do
  #       address = Address.create! valid_attributes
  #       put :update, {:id => address.to_param, :address => valid_attributes}, valid_session
  #       expect(response).to redirect_to(address)
  #     end
  #   end

  #   context "with invalid params" do
  #     it "assigns the address as @address" do
  #       address = Address.create! valid_attributes
  #       put :update, {:id => address.to_param, :address => invalid_attributes}, valid_session
  #       expect(assigns(:address)).to eq(address)
  #     end

  #     it "re-renders the 'edit' template" do
  #       address = Address.create! valid_attributes
  #       put :update, {:id => address.to_param, :address => invalid_attributes}, valid_session
  #       expect(response).to render_template("edit")
  #     end
  #   end
  # end
end
