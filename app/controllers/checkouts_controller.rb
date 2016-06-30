class CheckoutsController < ApplicationController
  include Wicked::Wizard
  include CookiesHandling
  
  steps :address, :shipment, :payment, :confirm, :complete

  before_action :authenticate_customer!
  before_action :setup_wizard

  def create
    @order = current_or_new_order.for_checkout(checkout_params)
    @checkout = Checkout.new(@order)
    
    if @checkout.valid? && @checkout.save
      redirect_to checkout_path(@order.next_step.to_sym)
    else
      redirect_to root_path, alert: "Can't checkout"
    end
  end

  def show
    @checkout = Checkout.new(last_processing_order)
      
    if @checkout
      redirect_if_wrong_step(@checkout.model.next_step, step) or return
      @checkout.init_empty_attributes(step)
      render_wizard
    else
      redirect_to root_path, notice: notice_when_checkout_is_nil(step)
    end
  end  

  def update
    @checkout = Checkout.new(current_order)

    hashes = CheckoutValidationHashForm.new(
      @checkout.model, 
      checkout_params, 
      steps, 
      step, 
      next_step,
      next_step_next?(@checkout.model.next_step, next_step))

    if @checkout.validate(hashes.validation_hash)
      render_wizard(@checkout)
    else
      redirect_to :back, {flash: { 
        errors: @checkout.errors, attrs: hashes.return_hash } }
    end
  end

  private

    def current_or_new_order
      current_order || Order.new(customer: current_customer)
    end

    def next_step_next?(prev_step, next_step)
      prev_index = steps.index(prev_step.to_sym)
      next_index = steps.index(next_step.to_sym)
      
      if !prev_index
        true
      elsif prev_index < next_index
        true
      else
        false
      end
    end

    def redirect_if_wrong_step(next_step, step)
      if !next_step
        redirect_to(order_items_index_path, 
          notice: "Please checkout first") and return
      elsif next_step_next?(next_step, step)
        redirect_to(checkout_path(next_step.to_sym), 
          notice: "Please proceed checkout from this step") and return
      end
      return true
    end
    
    def notice_when_checkout_is_nil(step)
      if step == :complete
        "You have no completed orders"
      elsif step == :confirm
        "You have no orders to confirm"
      else
        "Please checkout first"
      end
    end

    def checkout_params
      address = [:firstname,
                 :lastname,
                 :address1,
                 :address2,
                 :phone,
                 :city,
                 :zipcode,
                 :country_id,
                 :billing_address_for_id,
                 :shipping_address_for_id]

      credit_card = [:number, 
                     :cvv, 
                     :firstname, 
                     :lastname,
                     :expiration_month, 
                     :expiration_year,
                     :customer_id]

      model = [:total_price,
               :completed_date,
               :customer_id,
               :state,
               :next_step,
               :shipping_price,
               :shipping_method,
               billing_address: address,
               shipping_address: address,
               credit_card: credit_card]

      if params[:order]
        params.require(:order).permit(
        :coupon_code,
        model: model, 
        order_items_attrs: [:book_id, :quantity]).merge(
          params.permit(:use_billing))
      else
        nil
      end
    end
end