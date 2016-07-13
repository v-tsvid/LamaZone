require 'rails_helper'

RSpec.describe OrderItemsController, type: :controller do

  let(:book) { FactoryGirl.create :book }
  let(:customer) { FactoryGirl.create(:customer) }
  let(:order) { FactoryGirl.create :order }
  let(:order_items_params) { [{book_id: 1, quantity: 1}, {book_id: 2, quantity: 2}] }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:customer]
    sign_in customer
  end

  shared_examples "current order items destroying" do
    it "destroys current order items" do
      expect(order.order_items).to receive(:destroy_all)
      subject
    end
  end

  shared_examples "redirecting to order_items_path" do
    it "redirects to order_items_path" do
      expect(subject).to redirect_to order_items_path
    end
  end

  shared_examples "redirecting to :back" do
    it "redirects to :back" do
      expect(subject).to redirect_to(request.env["HTTP_REFERER"])
    end
  end

  describe "GET #index" do
    subject { get :index }
    let(:order_with_order_items) { FactoryGirl.create :order_with_order_items }

    shared_examples "redirecting to root" do
      it "redirects to root_path" do
        expect(subject).to redirect_to root_path
      end

      it "sets flash[:notice] to 'your cart is empty'" do
        subject
        expect(flash[:notice]).to eq "Your cart is empty"
      end
    end

    it "assigns :order_with_items as @order" do
      allow(controller).to receive(:order_with_items).and_return(
        order_with_order_items)
      subject
      expect(assigns(:order)).to eq order_with_order_items
    end

    context "when @order order items are empty" do
      before do
        allow(order_with_order_items.order_items).
          to receive(:empty?).and_return true
      end

      it_behaves_like "redirecting to root"
    end
  end

  describe "POST #create" do
    let(:params) { {book_id: book.id, quantity: 1} }
    let(:order_item) { FactoryGirl.create :order_item }

    subject { post :create, params }

    before do
      allow(OrderItem).to receive(:create).and_return order_item
      request.env["HTTP_REFERER"] = root_path
    end

    context "when current customer exists" do
      before do
        allow(controller).to receive(:current_customer).and_return customer
      end
    end

    context "when current customer doesn't exist" do
      before do
        allow(controller).to receive(:current_customer).and_return nil
      end
    end

    it_behaves_like "redirecting to :back"
  end

  describe "POST #destroy" do
    let!(:order_item) { FactoryGirl.create :order_item, order: order, book: book }

    before do
      request.env["HTTP_REFERER"] = root_path
      allow(controller).to receive(:current_order).and_return order
    end

    subject { delete :destroy, {id: order_item.id} }

    it "finds order item by requested order_item_id" do
      allow(OrderItem).to receive(:find_by).and_return order_item
      expect(OrderItem).to receive(:find_by).with(id: order_item.id.to_s)
      subject
    end

    it "destroys order item finded" do
      expect_any_instance_of(OrderItem).to receive(:destroy)
      subject
    end

    it "destroys current order if it has no order items" do
      allow_any_instance_of(OrderItem).to receive(:book).and_return book
      allow_any_instance_of(OrderItem).to receive(:[]).and_return nil
      expect_any_instance_of(Order).to receive(:destroy)
      subject
    end

    it_behaves_like "redirecting to :back"
  end
  
  describe "#order_with_items" do
  end
end
