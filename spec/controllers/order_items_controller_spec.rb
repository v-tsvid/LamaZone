require 'rails_helper'
require 'shared/controllers/shared_controllers_specs'

RSpec.describe OrderItemsController, type: :controller do

  let(:book) { FactoryGirl.create :book }
  let(:customer) { FactoryGirl.create(:customer) }
  let(:order) { FactoryGirl.create :order }
  let(:order_items_params) {
    [{book_id: 1, quantity: 1}, {book_id: 2, quantity: 2}] }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:customer]
    sign_in customer
  end

  describe "GET #index" do
    let(:order_with_order_items) { FactoryGirl.create :order_with_order_items }
    subject { get :index }

    it_behaves_like "authorize resource"
    it_behaves_like 'check abilities', :read, OrderItem

    before do 
      allow(controller).to receive(:get_order).and_return order_with_order_items
      allow_any_instance_of(OrderFiller).to receive(:add_items_to_order).
        and_return(order_with_order_items)
    end

    it "assigns order filled with items from params as @order" do
      subject
      expect(assigns :order).to eq order_with_order_items
    end
    
    it_behaves_like 'assigning', :order_items

    context "when @order has no order items" do
      before do
        allow(order_with_order_items.order_items).
          to receive(:empty?).and_return true
      end

      it "receives :destroy on @order" do
        expect(order_with_order_items).to receive(:destroy)
        subject
      end

      it_behaves_like "redirecting to root_path"
      it_behaves_like "flash setting", :notice, t("controllers.cart_is_empty")
    end
  end

  describe "POST #create" do
    let(:params) { {book_id: book.id, quantity: 1} }
    
    subject { post :create, params }

    it_behaves_like "authorize resource"
    it_behaves_like 'check abilities', :create, OrderItem

    before { request.env["HTTP_REFERER"] = cart_path }

    context "when current customer exists" do

      before do
        allow(controller).to receive(:current_customer).and_return customer
        allow_any_instance_of(OrderFiller).to receive(:add_items_to_order).
          and_return(order)
      end

      it "assigns order filled with items from params as @order" do
        subject
        expect(assigns :order).to eq order
      end
    end

    context "when current customer doesn't exist" do
      before do
        allow(controller).to receive(:current_customer).and_return nil
      end

      it "pushes order_item from params to cookies" do
        current_book = FactoryGirl.create :book
        request.cookies['order_items'] = "#{current_book.id} 2"
        subject
        expect(response.cookies['order_items']).to eq(
          " #{current_book.id} 2 #{book.id} 1")
      end
    end

    it_behaves_like "redirecting to :back"

    it_behaves_like('flash setting', :notice, 
      "\"title\" #{t("controllers.added")}") do
      before do
        allow(Book).to receive(:title_by_id).and_return 'title'
      end
    end
  end

  describe "DELETE #destroy" do
    let(:order_item) { 
      FactoryGirl.create :order_item, order: order, book: book }

    subject { delete :destroy, {id: order_item.id} }

    it_behaves_like "authorize resource"
    it_behaves_like 'check abilities', :destroy, OrderItem

    before do
      request.env["HTTP_REFERER"] = cart_path
      allow(controller).to receive(:current_order).and_return order
    end

    it_behaves_like 'assigning', :order_item

    context "if @order_item was found" do
      before do
        allow(OrderItem).to receive(:find_by).with(
          id: order_item.id.to_s).and_return order_item
      end

      it "destroys order item finded" do
        expect(order_item).to receive(:destroy)
        subject
      end
      
      it "destroys current order if it has no order items" do
        allow_any_instance_of(OrderItem).to receive(:book).and_return book
        allow_any_instance_of(OrderItem).to receive(:[]).and_return nil
        expect(order).to receive(:destroy)
        subject
      end

      it_behaves_like('flash setting', :notice, 
        "\"title\" #{t("controllers.removed")}") do
        before do
          allow_any_instance_of(Book).to receive(:title).and_return 'title'
        end
      end
    end

    context "if @order_item was not found" do
      before do
        allow(OrderItem).to receive(:find_by).and_return nil
      end

      it_behaves_like("flash setting", 
        :notice, t("controllers.failed_to_remove_book"))
    end

    it_behaves_like "redirecting to :back"
  end

  describe "DELETE #delete_from_cookies" do
    subject { delete :delete_from_cookies, {book_id: book.id} }

    it_behaves_like "authorize resource"
    
    before { request.env["HTTP_REFERER"] = cart_path }

    it "receives :interact_with_cookies" do
      expect(controller).to receive :interact_with_cookies
      subject
    end

    it "receives :pop_from_cookies" do
      expect(controller).to receive :pop_from_cookies
      subject
    end

    it "pops order_item from params from cookies" do
      another_book = FactoryGirl.create :book
      request.cookies['order_items'] = "#{book.id} 2 #{another_book.id} 3"
      subject
      expect(response.cookies['order_items']).to eq " #{another_book.id} 3"
    end

    it_behaves_like "redirecting to :back"
    
    it_behaves_like('flash setting', :notice, 
      "\"title\" #{t("controllers.removed")}") do
      before do
        allow(Book).to receive(:title_by_id).and_return 'title'
      end
    end
  end
end
