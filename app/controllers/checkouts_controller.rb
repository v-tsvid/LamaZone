class CheckoutsController < ApplicationController
  include Wicked::Wizard
  include CookiesHandling
  
  steps :address, :shipment, :payment, :confirm, :complete

  before_action :authenticate_customer!
  before_action :setup_wizard

  def create
    @checkout_form = CheckoutForm.new(current_or_new_order.for_checkout(checkout_params))
    
    if @checkout_form.valid? && @checkout_form.save
      redirect_to checkout_path(@checkout_form.model.next_step.to_sym)
    else
      redirect_to root_path, alert: "Can't checkout"
    end
  end

  def show
    @checkout_form = CheckoutForm.new(last_processing_order)
      
    if @checkout_form
      redirect_if_wrong_step(@checkout_form.model.next_step, step) or return
      @checkout_form.init_empty_attributes(step)
      render_wizard
    else
      redirect_to root_path, notice: notice_when_checkout_is_nil(step)
    end
  end  

  def update
    @checkout_form = CheckoutForm.new(current_order)

    hashes = CheckoutValidationHashForm.new(
      @checkout_form.model, 
      checkout_params, 
      steps, 
      step, 
      next_step,
      next_step_next?(@checkout_form.model.next_step, next_step))

    if @checkout_form.validate(hashes.validation_hash)
      render_wizard(@checkout_form)
    else
      redirect_to :back, {flash: { 
        errors: @checkout_form.errors, attrs: hashes.return_hash } }
    end
  end

  private

    def current_or_new_order
      current_order || Order.new(customer: current_customer)
    end

    def next_step_next?(prev_step, next_step)
      prev_index = steps.index(prev_step.to_sym)
      next_index = steps.index(next_step.to_sym)
      
      !prev_index || prev_index < next_index
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
      case step
      when :complete then "You have no completed orders"
      when :confirm then "You have no orders to confirm"
      else "Please checkout first"
      end
    end

    def checkout_params
      if params[:order]
        params.require(:order).permit(
        :coupon_code,
        model: model_params, 
        order_items_attrs: [:book_id, :quantity]).merge(
          params.permit(:use_billing))
      else
        nil
      end
    end

    def address_params
      [:firstname,
       :lastname,
       :address1,
       :address2,
       :phone,
       :city,
       :zipcode,
       :country_id,
       :billing_address_for_id,
       :shipping_address_for_id]
    end

    def credit_card_params
      [:number, 
       :cvv, 
       :firstname, 
       :lastname,
       :expiration_month, 
       :expiration_year,
       :customer_id]
    end

    def model_params
      [:total_price,
       :completed_date,
       :customer_id,
       :state,
       :next_step,
       :shipping_price,
       :shipping_method,
       billing_address: address_params,
       shipping_address: address_params,
       credit_card: credit_card_params]
    end
end