require 'rails_helper'

RSpec.describe OrderItemsController, type: :controller do
  
  let(:customer) { FactoryGirl.create(:customer) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:customer]
    sign_in customer
  end

  describe "POST #update_cart" do
    # subject { post :update_cart, { order: order_params } }

    context "when current order exists" do
    end

    context "when current order doesn't exist" do
    end

    # it "redirects to order_items_path" do
    #   expect(subject).to redirect_to order_items_path
    # end
  end

  describe "DELETE #empty_cart" do
  end

  describe "POST #add_to_cart" do
  end

  describe "POST #remove_from_cart" do
  end

  describe "GET #index" do
  end

  describe "#order_with_order_items" do
  end

  describe "#combine_with_cookies" do
  end

  describe "#compact_if_not_compacted" do
  end

  describe "#current_order_items_from_params" do
  end

  describe "#order_items_from_params" do
  end  
end
