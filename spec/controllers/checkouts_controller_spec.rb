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
      # model: FactoryGirl.attributes_for(:order), 
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
    it "receives customer_authenticate!" do
      expect(controller).to receive(:authenticate_customer!)
    end
  end

  describe "POST #create" do

    it "assigns checkout within @order as @checkout" do
      allow(Order).to receive(:new).and_return(order)
      post :create, { order: order_params }
      expect(assigns(:checkout).model.id).to eq order.id
    end

    it "receives current_order" do
      expect(controller).to receive :current_order
      post :create, { order: order_params }
    end

    it "receives init_order" do
      expect(controller).to receive :init_order
      post :create, { order: order_params }
    end
    
    context "if there is no current_order" do

      it "creates new Order for current_customer" do
        allow(controller).to receive(:current_customer).and_return(customer)
        post :create, { order: order_params }
        expect(assigns(:order).customer).to eq customer
      end

      after { post :create, { order: order_params } }

      it "receives current_customer" do
        expect(controller).to receive(:current_customer).twice
      end

      it "receives new on Order" do
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
          expect(flash[:alert]).to eq "Can't create order"
        end
      end
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
        allow(controller).to receive(:redirect_if_wrong_step).and_return true
      end

      context "if checkout was created" do
        it "receives redirect_if_wrong_step with #{step} step" do
          controller.instance_variable_set(:@checkout, Checkout.new(order))
          expect(controller).to receive(:redirect_if_wrong_step).with(step)
          get :show, { id: step }
        end
      end

      context "if step wasn't wrong" do
        it "receives redirect_if_checkout_is_nil" do
          expect(controller).to receive(:redirect_if_checkout_is_nil).with(step)
          get :show, { id: step }
        end
      end

      context "if no redirects was performed" do
        it "renders the view for #{step} step" do
          allow(controller).to receive(:redirect_if_checkout_is_nil).and_return false
          expect(get :show, { id: step }).to render_template(step.to_s)
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
                allow(controller).to receive(:redirect_if_wrong_step).
                  and_return true
              end

              it "receives init_address with #{address}" do
                expect(controller).to receive(:init_address).with(address)
                get :show, { id: step }
              end

              it "sets #{spaced(address)} with init_address method" do
                get :show, { id: step }
                expect(assigns(:checkout).model.send(address)).
                  to eq controller.send(:init_address, address)
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
              allow(controller).to receive(:redirect_if_wrong_step).
                and_return true
              allow(CreditCard).to receive(:new).and_return credit_card
            end

            it "receives new on CreditCard" do
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
            allow(controller).to receive(:redirect_if_wrong_step).
              and_return true
            get :show, { id: step }
            expect(assigns(:checkout).model).to eq last_proc_order
          end
        end
      end
    end
  end

  describe "POST #update" do
  end
end