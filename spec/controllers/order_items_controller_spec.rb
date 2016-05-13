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

  shared_examples "order item creating" do |ord|
    it "creates order item with passed params and #{ord} order id" do
      expect(OrderItem).to receive(:create).with(
        book_id: params[:book_id].to_s, 
        quantity: params[:quantity].to_s, 
        order: order)
      subject
    end
  end

  shared_examples ":compact_if_not_compacted" do
    it "receives :compact_if_not_compacted with order.order_items" do
      expect(controller).to receive(:compact_if_not_compacted).with(order.order_items)
      subject
    end
  end

  shared_examples "redirecting to :back" do
    it "redirects to :back" do
      expect(subject).to redirect_to(request.env["HTTP_REFERER"])
    end
  end

  shared_examples "notice added or removed" do |add_or_remove|
    it "sets flash[:notice] to 'book title' was #{add_or_remove} the cart" do
      subject
      expect(flash[:notice]).to eq "\"#{Book.find(book.id).title}\" " \
                                 "was #{add_or_remove} the cart"
    end
  end

  describe "POST #update_cart" do
    let(:order_items) { FactoryGirl.create_list :order_item, 2 }

    subject { post :update_cart, { order_items_params: order_items_params } }

    context "when current order exists" do
      
      before do
        allow(controller).to receive(:current_order).and_return order
        allow(controller).to receive(
          :current_order_items_from_params).and_return order_items
      end

      it_behaves_like "current order items destroying"

      it "assigns :current_order_items_from_params as @order_items" do
        subject
        expect(assigns(:order_items)).to eq order_items
      end
    end

    context "when current order doesn't exist" do
      before do
        allow(controller).to receive(:current_order).and_return nil
        allow(controller).to receive(
          :order_items_from_params).and_return order_items
      end

      it "assigns :order_items_from_params as @order_items" do
        subject
        expect(assigns(:order_items)).to eq order_items
      end

      it "receives :write_to_cookies with @order_items" do
        expect(controller).to receive(:write_to_cookies).with(order_items)
        subject
      end
    end

    it_behaves_like "redirecting to order_items_path"
  end

  describe "DELETE #empty_cart" do

    subject { delete :empty_cart }

    context "when current order exists" do

      before { allow(controller).to receive(:current_order).and_return order }

      it_behaves_like "current order items destroying"

      it "destroys current order" do
        expect(order).to receive(:destroy)
        subject
      end
    end

    context "when current order doesn't exist" do
      before { allow(controller).to receive(:current_order).and_return nil }

      it "removes key 'order_items' from cookies" do
        expect_any_instance_of(ActionDispatch::Cookies::CookieJar).to receive(
          :delete).with('order_items')
        subject
      end
    end

    it_behaves_like "redirecting to order_items_path"
  end

  describe "POST #add_to_cart" do
    let(:params) { {book_id: book.id, quantity: 1} }
    let(:order_item) { FactoryGirl.create :order_item }

    subject { post :add_to_cart, params }

    before do
      allow(OrderItem).to receive(:create).and_return order_item
      request.env["HTTP_REFERER"] = root_path
    end

    context "when current customer exists" do
      before do
        allow(controller).to receive(:current_customer).and_return customer
      end

      context "when current order exists" do
        let(:order) { FactoryGirl.create :order, customer: customer }
        before { allow(controller).to receive(:current_order).and_return order }

        it_behaves_like ":compact_if_not_compacted"
        it_behaves_like "order item creating", 'current'
      end

      context "when current_order doesn't exist" do
        let(:order) { Order.new(customer: customer) }
        before do 
          allow(Order).to receive(:new).and_return order
          allow(controller).to receive(:current_order).and_return nil 
        end

        it "receives :new on Order with current customer" do
          expect(Order).to receive(:new).with(customer: customer)
          subject
        end

        it_behaves_like ":compact_if_not_compacted"
        it_behaves_like "order item creating", 'new'
      end

      it "receives save! on order" do
        expect_any_instance_of(Order).to receive(:save!)
        subject
      end

      context "if order wasn't saved" do
        before do 
          allow_any_instance_of(Order).to receive(:save!).and_return false
        end

        it_behaves_like "redirecting to :back"

        it "sets flash[:alert] to \"Can't add book\"" do
          subject
          expect(flash[:alert]).to eq "Can't add book"
        end
      end
    end

    context "when current customer doesn't exist" do
      before do
        allow(controller).to receive(:current_customer).and_return nil
      end

      it "receives :push_to_cookies" do
        expect(controller).to receive(:push_to_cookies)
        subject
      end
    end

    it_behaves_like "redirecting to :back"
    it_behaves_like "notice added or removed", "added to"
  end

  describe "POST #remove_from_cart" do
    let(:params) { {book_id: book.id} }
    let!(:order_item) { FactoryGirl.create :order_item, order: order, book: book }

    subject { post :remove_from_cart, params }

    before do
      request.env["HTTP_REFERER"] = root_path
    end

    context "when current order exists" do
      before do
        allow(controller).to receive(:current_order).and_return order
      end

      it "finds order item of current order with requested book_id" do
        allow(OrderItem).to receive(:find_by).and_return order_item
        expect(OrderItem).to receive(:find_by).with(
          order_id: order.id, book_id: book.id.to_s)
        subject
      end
      it "destroys order item finded" do
        expect_any_instance_of(OrderItem).to receive(:destroy)
        subject
      end

      it "destroys current order if it has no order items" do
        allow_any_instance_of(OrderItem).to receive(:[]).and_return nil
        expect_any_instance_of(Order).to receive(:destroy)
        subject
      end
    end

    context "when current order doesn't exist" do
      before do
        allow(controller).to receive(:current_order).and_return nil
      end

      it "receives :pop_from_cookies" do
        expect(controller).to receive(:pop_from_cookies)
        subject
      end
    end

    it_behaves_like "redirecting to :back"
    it_behaves_like "notice added or removed", "removed from"
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

    it "assigns :order_with_order_items as @order" do
      allow(controller).to receive(:order_with_order_items).and_return(
        order_with_order_items)
      subject
      expect(assigns(:order)).to eq order_with_order_items
    end

    context "when @order assigned to nil" do
      before do
        allow(controller).to receive(:order_with_order_items).and_return nil
      end

      it_behaves_like "redirecting to root"
    end

    context "when @order order items are empty" do
      before do
        allow(order_with_order_items.order_items).
          to receive(:empty?).and_return true
      end

      it_behaves_like "redirecting to root"
    end
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
