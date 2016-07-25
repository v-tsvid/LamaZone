require 'rails_helper'
require 'shared/controllers/shared_controllers_specs'
require 'shared/controllers/shared_checkouts_controller_specs'

RSpec.describe CheckoutsController, type: :controller do
  
  let(:step) { CheckoutForm::NEXT_STEPS.sample }
  let(:customer) { FactoryGirl.create :customer }
  let(:order_items) { FactoryGirl.create_list :order_item, 2, order: nil }
  let(:order) { FactoryGirl.create :order }
  let(:new_checkout) { CheckoutForm.new(order) }
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

  describe "POST #create" do

    subject { post :create, { order: order_params } }

    it_behaves_like 'customer authentication'
    it_behaves_like 'setting up wizard'
    it_behaves_like 'assigning', :checkout_form

    before { allow(CheckoutForm).to receive(:new).and_return new_checkout }

    it "receives :prepare_for_checkout on current_customers_order" do
      allow(controller).to receive(:current_customers_order).and_return order
      expect(order).to receive(:prepare_for_checkout).
        with(order_params[:coupon_code])
      subject
    end

    it_behaves_like "new checkout form" do
      before do
        allow_any_instance_of(Order).to receive(:prepare_for_checkout).
          with(order_params[:coupon_code]).and_return order
      end
    end

    context 'when checkout_form is valid and was saved' do
      before do
        allow_any_instance_of(CheckoutForm).to receive(:valid?).and_return true
        allow_any_instance_of(CheckoutForm).to receive(:save).and_return true
      end

      it "redirects to checkout next step" do
        expect(subject).to redirect_to(
          checkout_path(assigns(:checkout_form).model.next_step.to_sym))
      end
    end

    context "when checkout_form wasn't saved" do
      before do 
        allow_any_instance_of(CheckoutForm).to receive(:save).and_return false
      end

      it_behaves_like 'redirecting to root_path'
      it_behaves_like 'flash setting', :alert, t("controllers.checkout_failed")
    end
  end

  describe "GET #show" do
    subject { get :show, { id: step } }

    it_behaves_like 'customer authentication'
    it_behaves_like 'setting up wizard'

    context 'when last_order exists' do
      before { allow(controller).to receive(:last_order).and_return order }
      
      it_behaves_like 'new checkout form'
      it_behaves_like 'assigning', :checkout_form
    end

    context "if @checkout_form was created" do
      before do
        allow(controller).to receive(:last_order).and_return order
        allow(controller).to receive(:redirect_if_wrong_step).and_return nil
      end

      it "receives :redirect_if_wrong_step" do
        expect(controller).to receive(:redirect_if_wrong_step)
        subject
      end

      context "if :redirect_if_wrong_step returns nil" do
        before do
          allow(controller).to receive(:redirect_if_wrong_step).and_return nil
        end

        it "receives :init_empty_attributes on @checkout_form" do
          allow(CheckoutForm).to receive(:new).and_return new_checkout
          expect(new_checkout).to receive(:init_empty_attributes).with step
          subject
        end

        it "receives :render_wizard" do
          allow(controller).to receive(:render).and_return nil
          expect(controller).to receive(:render_wizard)
          subject
        end
      end
    end

    context "if @checkout_form was not created" do
      before do
        allow(controller).to receive(:last_order).and_return nil
      end

      it_behaves_like 'redirecting to root_path'

      it_behaves_like 'flash setting', :notice, 'notice' do
        before do
          allow(controller).to receive(:notice_when_checkout_is_nil).
            and_return 'notice'
        end
      end
    end
  end

  describe "POST #update" do

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

    let(:checkout_validation_hash_form) { CheckoutValidationHashForm.new(
      order, update_order_params, CheckoutForm::NEXT_STEPS, 
      step, order.next_step, false)
    }

    subject do
      put :update, { id: step, order: update_order_params }
    end

    before do
      allow(CheckoutForm).to receive(:new).and_return new_checkout
      allow(controller).to receive(:next_step).and_return(
        CheckoutForm::NEXT_STEPS.sample)
      request.env["HTTP_REFERER"] = cart_path
    end

    it_behaves_like 'customer authentication'
    it_behaves_like 'setting up wizard'
    it_behaves_like 'new checkout form' do
      before { allow(controller).to receive(:current_order).and_return order }
    end
    it_behaves_like 'assigning', :checkout_form

    it "creates checkout_validation_hash_form" do
      allow(CheckoutValidationHashForm).to receive(:new).and_return(
        checkout_validation_hash_form)
      expect(CheckoutValidationHashForm).to receive(:new)
      subject
    end

    it "validates @checkout_form with validation_hash" do
      allow_any_instance_of(CheckoutValidationHashForm).to receive(
        :validation_hash).and_return({key: 'value'})
      expect_any_instance_of(CheckoutForm).to receive(
        :validate).with({key: 'value'})
      subject
    end

    context "when @checkout_form valid" do
      before do
        allow_any_instance_of(CheckoutForm).to receive(
          :validate).and_return true
      end

      it "receives :render_wizard with @checkout_form" do
        allow(controller).to receive(:render).and_return nil
        expect(controller).to receive(:render_wizard).with(new_checkout)
        subject
      end
    end

    context "when @checkout_form invalid" do
      before do
        allow_any_instance_of(CheckoutForm).to receive(
          :validate).and_return false
      end

      it_behaves_like 'redirecting to :back'

      it_behaves_like 'flash setting', :errors, {error: 'error_value'} do
        before do
          allow_any_instance_of(CheckoutForm).to receive(:errors).and_return(
            {error: 'error_value'})
        end
      end

      it_behaves_like 'flash setting', :attrs, {return: 'return_value'} do
        before do
          allow_any_instance_of(CheckoutValidationHashForm).to receive(
            :return_hash).and_return({return: 'return_value'})
        end
      end
    end
  end
end