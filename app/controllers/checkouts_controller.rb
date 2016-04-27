class CheckoutsController < ApplicationController
  include Wicked::Wizard
  include CookiesHandling

  before_action :authenticate_customer!

  steps :address, :shipment, :payment, :confirm, :complete

  def new
    @checkout = Checkout.new(Order.new)
  end

  def create
    @order = current_order || Order.new(customer: current_customer)
    init_order
    @checkout = Checkout.new(@order)
    
    if @checkout.valid? && @checkout.save
      redirect_to checkout_path(@order.next_step.to_sym)
    else
      redirect_to root_path, alert: "Can't create order"
    end
  end

  def show
    @checkout = Checkout.new(current_order) if current_order
    case step
    when :address
      if @checkout  
        redirect_if_wrong_step(:address) or return
        @checkout.model.billing_address ||= init_address(:billing_address)
        @checkout.model.shipping_address ||= init_address(:shipping_address)
      end
    when :shipment
      redirect_if_wrong_step(:shipment) or return if @checkout
    when :payment
      if @checkout
        redirect_if_wrong_step(:payment) or return
        @checkout.model.credit_card ||= CreditCard.new 
      end
    when :confirm
      redirect_if_wrong_step(:confirm) or return if @checkout
    when :complete
      @checkout = Checkout.new(last_processing_order) if last_processing_order
      redirect_if_wrong_step(:complete) or return if @checkout
    end
    redirect_if_nil(step, @checkout)
  end  

  def update
    @checkout = Checkout.new(current_order)
    case step
    when :address
      @validation_hash = set_next_step(@checkout.model.next_step, 'shipment')
      @validation_hash.merge!(checkout_params['model'])
      @return_hash = { billing_address: @validation_hash['billing_address'], 
                       shipping_address: @validation_hash['shipping_address'] }

      if params['use_billing']
        @validation_hash.merge!(
              {shipping_address: checkout_params['model']['billing_address']})
        @return_hash['shipping_address'] = @validation_hash['billing_address']
      end
    when :shipment
      @validation_hash = set_next_step(@checkout.model.next_step, 'payment')
      @validation_hash.merge!(checkout_params['model'])
      @return_hash = {shipping_method: checkout_params['model']['shipping_method'],
        shipping_price: checkout_params['model']['shipping_price']}
    when :payment
      @validation_hash = set_next_step(@checkout.model.next_step, 'confirm')
      @validation_hash.merge!(checkout_params['model'])
      @return_hash = @validation_hash['credit_card']
    when :confirm
      @validation_hash = set_next_step(@checkout.model.next_step, 'complete')
      @validation_hash.merge!({state: "processing"})
      @return_hash = nil
    end
    save_and_render
  end


  private

    def init_order
      coupon = Coupon.find_by(code: checkout_params[:coupon_code]) || nil

      if checkout_params[:order_items_attrs]
        order_items = checkout_params[:order_items_attrs].map do |item|
          OrderItem.new({book_id: item['book_id'], quantity: item['quantity']})
        end
      else
        order_items = Array.new
      end

      @order.next_step = 'address' unless @order.next_step
      @order.coupon = coupon if Coupon.exists?(coupon)
      @order.order_items.destroy_all
      @order.order_items = compact_order_items(order_items)
    end

    def init_address(address)
      if current_customer.send(address)
        attrs = current_customer.send(address).attributes
      else
        attrs = nil
      end
      
      Address.new(attrs)
    end

    def redirect_if_wrong_step(step)
      next_step = @checkout.model.next_step
      if next_step.nil?
        redirect_to(order_items_index_path, 
          notice: "Please checkout first") and return
      elsif next_step_next?(next_step, step)
        redirect_to(checkout_path(@checkout.model.next_step.to_sym), 
          notice: "Please proceed checkout from this step") and return
      end
      return true
    end

    def save_and_render
      if @checkout.validate(@validation_hash)
        render_wizard @checkout
      else
        redirect_to :back, {flash: { 
          errors: @checkout.errors, attrs: @return_hash } } 
      end 
    end

    def redirect_if_nil(step, checkout)
      if checkout
        render_wizard 
      elsif step == :complete
        redirect_to root_path, notice: "Please, check for your orders in processing" \
                                       "on your Orders page"
      else
        redirect_to root_path, notice: "You have no orders to confirm"
      end
    end

    def set_next_step(prev_step, next_step)
      val_hash = @checkout.model.attributes
      if next_step_next?(prev_step, next_step)
        val_hash = val_hash.merge({next_step: next_step}) 
      end
      val_hash
    end

    def next_step_next?(prev_step, next_step)
      prev_index = Checkout::NEXT_STEPS.index(prev_step.to_sym)
      next_index = Checkout::NEXT_STEPS.index(next_step.to_sym)
      if prev_index.nil?
        true
      elsif prev_index < next_index
        true
      else
        false
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

      params.require(:order).permit(
        :coupon_code,
        model: model, 
        order_items_attrs: [:book_id, :quantity, :price])
    end
end