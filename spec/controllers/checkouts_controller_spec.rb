require 'rails_helper'

RSpec.describe CheckoutsController, type: :controller do
  
  let(:customer) { FactoryGirl.create :customer }
  let(:new_checkout) { Checkout.new(Order.new) }
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

    it "assigns checkout within @order as @checkout" do
      allow(Order).to receive(:new).and_return(order)
      post :create, { order: order_params }
      expect(assigns(:checkout).model.id).to eq order.id
    end

    it "receives :current_order" do
      expect(controller).to receive :current_order
      post :create, { order: order_params }
    end
    
    context "if there is no current_order" do

      it "creates new Order for current_customer" do
        allow(controller).to receive(:current_customer).and_return(customer)
        post :create, { order: order_params }
        expect(assigns(:order).customer).to eq customer
      end

      after { post :create, { order: order_params } }

      it "receives :current_customer" do
        expect(controller).to receive(:current_customer).twice
      end

      it "receives :new on Order" do
        allow(controller).to receive(:current_customer).and_return(customer)
        expect(Order).to receive(:new).with(customer: customer).and_return(order)
      end
    end

    context 'redirects' do
      subject { post :create, { order: order_params } }

      context 'if checkout is valid and was saved' do
        it "redirects to checkout next step" do
          allow_any_instance_of(Checkout).to receive(:valid?).and_return true
          allow_any_instance_of(Checkout).to receive(:save).and_return true
          expect(subject).to redirect_to(
            checkout_path(assigns(:checkout).model.next_step.to_sym))
        end
      end

      context "if checkout wasn't saved" do
        it "redirects to root with error message" do
          allow_any_instance_of(Checkout).to receive(:save).and_return false
          expect(subject).to redirect_to root_path
          subject
          expect(flash[:alert]).to eq "Can't checkout"
        end
      end
    end
    
    it_behaves_like "customer authentication" do
      after { post :create, { order: order_params } }
    end
  end

  describe "GET #show" do
    shared_examples "show action block" do |step|
      it "creates new checkout within current order if it exists" do
        allow(controller).to receive(:current_order).and_return(order)
        expect(Checkout).to receive(:new).with(order)
        get :show, { id: step }
      end

      before do
        allow(controller).
          to receive(:redirect_if_wrong_step).and_return true
      end

      context "if checkout was created" do
        it "receives :redirect_if_wrong_step with #{step} step" do
          controller.instance_variable_set(:@checkout, Checkout.new(order))
          expect(controller).to receive(:redirect_if_wrong_step).with(
            assigns(:checkout).model.next_step, step)
          get :show, { id: step }
        end
      end

      context "if step wasn't wrong" do
        it "receives :notice_when_checkout_is_nil" do
          expect(controller).to receive(:notice_when_checkout_is_nil).with(step)
          get :show, { id: step }
        end
      end
    end

    CheckoutsController::WIZARD_STEPS.each do |step|
      context "the #{step} step" do
        it_behaves_like 'show action block', step

        if step == :address
          [:billing_address, :shipping_address].each do |address|
            context "if checkout #{spaced(address)} is empty" do
              let(:order_without_addresses) {
                FactoryGirl.create :order, address => nil
              }

              before do
                allow(controller).to receive(:current_order).
                  and_return(order_without_addresses)
                allow_any_instance_of(CheckoutsController).
                  to receive(:redirect_if_wrong_step).and_return true
              end
            end
          end
        end
        
        if step == :payment
          context "if checkout credit card is empty" do
            let(:order_without_credit_card) {
              FactoryGirl.create :order, credit_card: nil
            }
            let(:credit_card) { CreditCard.new }

            before do
              allow(controller).to receive(:current_order).
                and_return(order_without_credit_card)
              allow_any_instance_of(CheckoutsController).
                to receive(:redirect_if_wrong_step).and_return true
              allow(CreditCard).to receive(:new).and_return credit_card
            end

            it "receives :new on CreditCard" do
              expect(CreditCard).to receive(:new)
              get :show, { id: step }
            end

            it "creates new credit card for checkout" do
              get :show, { id: step }
              expect(assigns(:checkout).model.credit_card).to eq credit_card
            end
          end
        end

        if step == :complete
          let(:last_proc_order) { FactoryGirl.create :order }

          it "assigns checkout created with last processing order as @checkout" do
            allow(controller).to receive(:last_processing_order).
              and_return(last_proc_order)
            allow_any_instance_of(CheckoutsController).
              to receive(:redirect_if_wrong_step).and_return true
            get :show, { id: step }
            expect(assigns(:checkout).model).to eq last_proc_order
          end
        end

        it_behaves_like "customer authentication" do
          after { get :show, { id: step } }
        end
      end
    end
  end

  describe "POST #update" do
    shared_examples "update action block" do |step, use_billing|
      before do
        allow(Checkout).to receive(:new).and_return Checkout.new(order)
        allow_any_instance_of(Checkout).to receive(:validate).and_return true
        @next_step = CheckoutsController::WIZARD_STEPS[
            CheckoutsController::WIZARD_STEPS.index(step) + 1]
      end

      it "creates new checkout within current order" do
        allow(controller).to receive(:current_order).and_return(order)
        expect(Checkout).to receive(:new).with(order)
        put :update, { id: step, order: update_order_params }
      end

      it "receives :set_next_step with the step next to current" do
        allow(controller).to receive(:set_next_step).
          and_return(update_order_params['model'])
        expect(controller).to receive(:set_next_step).with(order, @next_step.to_s)
        put :update, { id: step, order: update_order_params }
      end
      
      [:validation_hash, :return_hash].each do |item|
        unless item == :return_hash && step == :confirm
          it "assigns @#{item} properly" do
            if use_billing
              put :update, { id: step, 
                             order: update_order_params, 
                             use_billing: 'use_billing' }
            else
              put :update, { id: step, order: update_order_params }
            end

            if item == :validation_hash
              expect(assigns(item)).to eq val_hash
            elsif item == :return_hash
              expect(assigns(item)).to eq ret_hash
            end
          end
        end
      end

      it "receives :redirect_if_invalid" do
        expect(controller).to receive(:redirect_if_invalid)
        put :update, { id: step, order: update_order_params }
      end

      context "if redirect_if_invalid returns false" do
        subject { put :update, { id: step, order: update_order_params } }

        it 'redirects to the next checkout step' do
          allow_any_instance_of(CheckoutsController).
            to receive(:redirect_if_invalid).and_return false
          expect(subject).to redirect_to checkout_path(@next_step.to_s)
        end
      end
    
      it_behaves_like "customer authentication" do
        after { put :update, { id: step, order: update_order_params } }
      end
    end

    CheckoutsController::WIZARD_STEPS.reverse.drop(1).reverse.
      each_with_index do |step, index|

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
        allow(controller).to receive(:current_order).and_return step_order
        @next_step = CheckoutsController::WIZARD_STEPS[index + 1].to_s
        allow_any_instance_of(CheckoutsController).to receive(:set_next_step).
          with(order, @next_step).and_return(
            update_order_params['model'].merge('next_step' => @next_step))
      end

      context "the #{step} step" do
        if step == :address
        
          context "when 'use_billing' option was turned on" do
            let(:val_hash) {
              { 'next_step' => 'shipment' }.merge(
                update_order_params['model'].merge(
                  {'shipping_address' => 
                    update_order_params['model']['billing_address']}))
            }
            let(:ret_hash) { 
              { 'billing_address' => val_hash['billing_address'], 
                'shipping_address' => val_hash['billing_address'] } 
            }

            it_behaves_like 'update action block', step, true
          end

          context "when 'use_billing' option was turned off" do
            let(:val_hash) {
              { 'next_step' => 'shipment' }.merge(update_order_params['model'])
            }
            let(:ret_hash) { 
              { 'billing_address' => val_hash['billing_address'], 
                'shipping_address' => val_hash['shipping_address'] } 
            }
            it_behaves_like 'update action block', step, false
          end          
        end

        if step == :shipment
          let(:val_hash) {
            { 'next_step' => 'payment' }.merge(update_order_params['model'])
          }
          let(:ret_hash) { 
            {'shipping_method' => update_order_params['model']['shipping_method'],
             'shipping_price' => update_order_params['model']['shipping_price']}
          }
          it_behaves_like 'update action block', step, false
        end

        if step == :payment
          let(:val_hash) {
            { 'next_step' => 'confirm' }.merge(update_order_params['model'])
          }
          let(:ret_hash) { val_hash['credit_card'] }

          it_behaves_like 'update action block', step, false
        end

        if step == :confirm
          let(:val_hash) {
            update_order_params['model'].merge({'next_step' => 'complete'}).merge(
              {'state' => "processing"})
          }
          let(:ret_hash) { nil }
          
          it_behaves_like 'update action block', step, false
        end
      end
    end
  end
  
  describe "#set_steps" do
    it "returns WIZARD_STEPS constant" do
      expect(controller.send(:set_steps)).to eq CheckoutsController::WIZARD_STEPS
    end
  end

  describe "#redirect_if_wrong_step" do
    
    shared_context "set next_step" do
      subject { controller.send(:redirect_if_wrong_step, next_step, :shipment) }
    end

    shared_examples "return" do
      it "returns true" do
        allow(controller).to receive(:redirect_to)
        expect(subject).to eq true
      end
    end

    context "if @checkout.model.next_step is nil" do
      let(:next_step) { nil }
      include_context "set next_step"

      it "receives :redirect_to with cart path and proper flash message" do
        expect(controller).to receive(:redirect_to).with(
          order_items_index_path, notice: "Please checkout first")
        subject
      end

      it_behaves_like "return"
    end

    context "if @checkout.model.next_step is not nil and "\
            "current step is next to it" do
      let(:next_step) { :address }
      include_context "set next_step"

      it "receives :redirect_to with current checkout step path and "\
         "proper flash message" do
        expect(controller).to receive(:redirect_to).with(
          checkout_path(next_step), 
          notice: "Please proceed checkout from this step")
        subject
      end

      it_behaves_like "return"
    end

    context "if @checkout.model.next_step is not nil and "\
            "current step is NOT next to it" do
      let(:next_step) { :shipment }
      include_context "set next_step"

      it "doesn't receives :redirect_to" do
        expect(controller).not_to receive(:redirect_to)
        subject
      end

      it_behaves_like "return"
    end
  end

  describe "#redirect_if_invalid" do

    let(:order) { FactoryGirl.build :order }
    let(:checkout) { Checkout.new(order) }
    let(:validation_hash) { {} }
    let(:return_hash) { {key: 'value'} }

    subject { controller.send(
      :redirect_if_invalid, checkout, validation_hash, return_hash) }

    context "if @checkout validates with @validate_hash" do
      it "returns false" do
        allow_any_instance_of(Checkout).to receive(:validate).and_return true
        expect(subject).to eq false
      end
    end

    context "if @checkout doesn't validate with @validate_hash" do
      before do
        allow_any_instance_of(Checkout).to receive(:validate).and_return false
      end

      it "receives :redirect_to with :back, flash errors and attrs" do
        expect(controller).to receive(:redirect_to).with(
          :back, {flash: { 
            errors: checkout.errors, attrs: return_hash } })
        subject
      end

      it "returns true" do
        allow(controller).to receive(:redirect_to)
        expect(subject).to eq true
      end
    end
  end

  describe "#notice_when_checkout_is_nil" do

    shared_examples "return message" do
      it "returns message" do
        expect(subject).to eq message
      end
    end

    subject { controller.send(:notice_when_checkout_is_nil, :address) }

    before do 
      controller.instance_variable_set(
        :@checkout, Checkout.new(FactoryGirl.build(:order)))
    end    

    context "if step is :complete" do
      subject { controller.send(:notice_when_checkout_is_nil, :complete) }
      let(:message) { "You have no completed orders" }

      it_behaves_like "return message"
    end

    context "if is :confirm" do
      subject { controller.send(:notice_when_checkout_is_nil, :confirm) }
      let(:message) { "You have no orders to confirm" }

      it_behaves_like "return message"
    end

    context "if step is not :complete or :confirm" do
      subject { controller.send(:notice_when_checkout_is_nil, :address) }
      let(:message) { "Please checkout first" }

      it_behaves_like "return message"
    end
  end

  describe "#set_next_step" do
    before do
      controller.instance_variable_set(
        :@checkout, Checkout.new(FactoryGirl.build(:order, next_step: 'payment')))
    end

    context "if checkout progress already went farther than current step" do
      it "returns @checkout.model.attributes" do
        expect(controller.send(:set_next_step, assigns(:checkout).model, :shipment)).to eq(
          assigns(:checkout).model.attributes)
      end
    end

    context "if checkout progress didn't went farther than current step yet" do
      it "returns @checkout.model.attributes with next_step updated to current" do
        expect(controller.send(:set_next_step, assigns(:checkout).model, :payment)).to eq(
          assigns(:checkout).model.attributes.merge({'next_step' => 'payment'}))
      end
    end
  end

  describe "#next_step_next?" do
    context "if there's no prev_step in the steps list" do
      it "returns true" do
        expect(controller.send(:next_step_next?, 'invalid', 'address')).to eq true
      end
    end

    context "if prev_step is preceding to next_step" do
      it "returns true" do
        expect(controller.send(:next_step_next?, 'address', 'shipment')).to eq true
      end
    end

    context "if prev_step is equal to next_step" do
      it "returns false" do
        expect(controller.send(:next_step_next?, 'address', 'address')).to eq false
      end
    end

    context "if prev_step is following to next_step" do
      it "returns false" do
        expect(controller.send(:next_step_next?, 'shipment', 'address')).to eq false
      end
    end
  end
end