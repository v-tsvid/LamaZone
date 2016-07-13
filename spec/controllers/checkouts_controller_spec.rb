require 'rails_helper'

RSpec.describe CheckoutsController, type: :controller do
  
  let(:customer) { FactoryGirl.create :customer }
  let(:new_checkout) { CheckoutForm.new(Order.new) }
  let(:order_items) { FactoryGirl.create_list :order_item, 2, order: nil }
  let(:order) { FactoryGirl.create :order }
  let(:coupon) { Coupon.all.sample }

  let(:order_params) {
    {
      coupon_code: coupon.code,
      order_items_attrs: [
        {book_id: order_items[0].book_id, quantity: order_items[0].quantity},
        {book_id: order_items[1].book_id, quantity: order_items[1].quantity}
      ]
    }
  }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:customer]
    sign_in customer
  end

  shared_examples "customer authentication" do
    it "receives :authenticate_customer!" do
      expect(controller).to receive(:authenticate_customer!)
    end
  end

  describe "POST #create" do

    # it "assigns checkout within @order as @checkout" do
    #   allow(Order).to receive(:new).and_return(order)
    #   post :create, { order: order_params }
    #   expect(assigns(:checkout).model.id).to eq order.id
    # end

    context 'redirects' do
      subject { post :create, { order: order_params } }

      context 'if checkout is valid and was saved' do
        it "redirects to checkout next step" do
          allow_any_instance_of(CheckoutForm).to receive(:valid?).and_return true
          allow_any_instance_of(CheckoutForm).to receive(:save).and_return true
          expect(subject).to redirect_to(
            checkout_path(assigns(:checkout_form).model.next_step.to_sym))
        end
      end

      context "if checkout wasn't saved" do
        it "redirects to root with error message" do
          allow_any_instance_of(CheckoutForm).to receive(:save).and_return false
          expect(subject).to redirect_to root_path
          subject
          expect(flash[:alert]).to eq t("controllers.checkout_failed")
        end
      end
    end
    
    it_behaves_like "customer authentication" do
      after { post :create, { order: order_params } }
    end
  end

  describe "GET #show" do
    shared_examples "show action block" do |step|
      it "creates new checkout within last order if it exists" do
        allow(controller).to receive(:last_order).and_return(order)
        expect(CheckoutForm).to receive(:new).with(order)
        get :show, { id: step }
      end

      before do
        allow(controller).
          to receive(:redirect_if_wrong_step).and_return true
      end

      # context "if checkout was created" do
        # it "receives :redirect_if_wrong_step with #{step} step" do
        #   controller.instance_variable_set(:@checkout_form, CheckoutForm.new(order))
        #   expect(controller).to receive(:redirect_if_wrong_step).with(
        #     assigns(:checkout_form), step)
        #   get :show, { id: step }
        # end
      # end

      context "if step wasn't wrong" do
        it "receives :notice_when_checkout_is_nil" do
          expect(controller).to receive(:notice_when_checkout_is_nil).with(step)
          get :show, { id: step }
        end
      end

      it_behaves_like "customer authentication" do
        after { get :show, { id: step } }
      end
    end

    CheckoutForm::NEXT_STEPS.reverse.drop(1).reverse.each do |step|
      it_behaves_like 'show action block', step
    end    
  end

  describe "POST #update" do
    shared_examples "update action block" do |step|

      let(:bil_address) { FactoryGirl.attributes_for :address }
      let(:ship_address) { FactoryGirl.attributes_for :address }
      let(:step_order) { FactoryGirl.create :order }
      let(:update_order_params) {
        {
          'model' => stringify_hash(step_order.attributes).merge(
            'billing_address' => stringify_hash(bil_address), 
            'shipping_address' => stringify_hash(ship_address), 
            'next_step' => 'address')
        }
      }

      before do
        allow(CheckoutForm).to receive(:new).and_return CheckoutForm.new(order)
        allow_any_instance_of(CheckoutForm).to receive(:validate).and_return true
        @next_step = CheckoutForm::NEXT_STEPS[
            CheckoutForm::NEXT_STEPS.index(step) + 1]
      end

      it "creates new checkout within current order" do
        allow(controller).to receive(:current_order).and_return(order)
        expect(CheckoutForm).to receive(:new).with(order)
        put :update, { id: step, order: update_order_params }
      end
    
      it_behaves_like "customer authentication" do
        after { put :update, { id: step, order: update_order_params } }
      end
    end

    CheckoutForm::NEXT_STEPS.reverse.drop(1).reverse.each do |step|
      it_behaves_like 'update action block', step
    end
  end
end