class CheckoutsController < ApplicationController
  include Wicked::Wizard
  include CheckoutRedirecting
  
  steps :address, :shipment, :payment, :confirm, :complete

  before_action :authenticate_customer!
  before_action :setup_wizard

  def create
    @checkout_form = CheckoutForm.new(
      current_customers_order.prepare_for_checkout(
        checkout_params[:coupon_code]))
    
    if @checkout_form.valid? && @checkout_form.save
      redirect_to checkout_path(@checkout_form.model.next_step.to_sym)
    else
      redirect_to root_path, alert: t("controllers.checkout_failed")
    end
  end

  def show
    @checkout_form = CheckoutForm.new(last_order) if last_order
      
    if @checkout_form
      redirect_if_wrong_step(@checkout_form, step)
      @checkout_form.init_empty_attributes(step)
      render_wizard
    else
      redirect_to root_path, notice: notice_when_checkout_is_nil(step)
    end
  end  

  def update
    @checkout_form = CheckoutForm.new(current_order)
    order = @checkout_form.model

    hashes = CheckoutValidationHashForm.new(
      order, 
      checkout_params, 
      steps, 
      step, 
      next_step,
      is_next?(order.next_step, next_step))

    if @checkout_form.validate(hashes.validation_hash)
      render_wizard(@checkout_form)
    else
      redirect_to :back, {flash: { 
        errors: @checkout_form.errors, attrs: hashes.return_hash } }
    end
  end

  private
    
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