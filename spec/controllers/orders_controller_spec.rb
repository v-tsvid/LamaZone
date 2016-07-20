require 'rails_helper'
require 'shared/shared_specs'

RSpec.describe OrdersController, type: :controller do

  shared_examples 'redirecting to cart_path' do
    it "redirects to cart_path" do
      expect(subject).to redirect_to cart_path
    end
  end
  
  let(:customer) { FactoryGirl.create :customer }
  let(:order) { FactoryGirl.create :order, customer: customer }
  let(:book) { FactoryGirl.create :book }
  let(:order_items_attrs) {
      [{book_id: 1, quantity: 1}, {book_id: 2, quantity: 2}] }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:customer]
    sign_in customer
  end

  describe "GET #index" do
    subject { get :index }

    it_behaves_like "load and authorize resource", :order
    it_behaves_like "check abilities", :read, Order
  end

  describe "GET #show" do  
    subject { get :show, {id: order.to_param} }

    it_behaves_like "load and authorize resource", :order
    it_behaves_like "check abilities", :read, Order
  end

  describe "PUT #update" do
    let(:order_with_items) { FactoryGirl.create :order_with_order_items }
    
    subject { 
      put :update, {id: order.id, order_items_attrs: order_items_attrs} }

    it_behaves_like 'authorize resource'
    it_behaves_like 'check abilities', :update, Order

    before do 
      allow(controller).to receive(:current_order).and_return order_with_items
      allow_any_instance_of(OrderFiller).to receive(:add_items_to_order).
        and_return(order_with_items)
    end

    it "destroys current_order order items" do
      expect(order_with_items.order_items).to receive(:destroy_all)
      subject
    end

    it "assigns order filled with items from params as @order" do
      subject
      expect(assigns :order).to eq order_with_items
    end
    
    it "assigns @order.order_items as @order_items" do
      subject
      expect(assigns :order_items).to eq order_with_items.order_items
    end

    it_behaves_like 'redirecting to cart_path'
    it_behaves_like "flash setting", :notice, t("controllers.updated")
  end

  describe "PUT #update_cookies" do

    subject { put :update_cookies, {order_items_attrs: order_items_attrs} }

    it_behaves_like "assigning", :order_items
    
    it "writes @order_items to cookies" do
      request.cookies['order_items'] = ''
      subject
      expect(response.cookies['order_items']).to eq ' 1 1 2 2'
    end

    it_behaves_like 'redirecting to cart_path'
    it_behaves_like "flash setting", :notice, t("controllers.updated")
  end

  describe "DELETE #destroy" do
    subject { delete :destroy, {id: order.id} }

    it_behaves_like 'authorize resource'
    it_behaves_like 'check abilities', :destroy, Order

    before { allow(controller).to receive(:current_order).and_return order }

    it_behaves_like 'assigning', :order

    it "destroys current_order" do
      expect(order).to receive(:destroy)
      subject
    end

    it_behaves_like 'redirecting to cart_path'
  end

  describe "DELETE #destroy_cookies" do
    subject { delete :destroy_cookies }

    it "deletes cookies['order_items']" do
      allow(controller).to receive(:cookies).and_return request.cookies
      expect(request.cookies).to receive(:delete).with('order_items')
      subject
    end

    it_behaves_like 'redirecting to cart_path'
  end
end
