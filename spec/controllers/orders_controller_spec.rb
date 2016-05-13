require 'rails_helper'
require 'controllers/shared/shared_controller_specs'

RSpec.describe OrdersController, type: :controller do
  
  let(:customer) { FactoryGirl.create :customer }
  let(:order) { FactoryGirl.create :order, customer: customer }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:customer]
    sign_in customer
  end

  describe "GET #index" do
    subject { get :index }

    it_behaves_like "load and authorize resource"

    it "assigns all orders as @orders" do
      subject
      expect(assigns(:orders)).to eq([order])
    end
  end

  describe "GET #show" do  
    subject { get :show, {id: order.to_param} }

    it_behaves_like "load and authorize resource"

    it "assigns the requested order as @order" do
      subject
      expect(assigns(:order)).to eq(order)
    end
  end
end
