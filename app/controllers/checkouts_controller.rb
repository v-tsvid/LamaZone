class CheckoutsController < ApplicationController
  include Wicked::Wizard

  before_action :authenticate_customer!

  steps :address, :shipment, :payment, :confirm, :complete

  def new
    @checkout = Checkout.new(Order.new)
  end

  def create
    @order_items = Array.new
    
    if checkout_params[:order_items_attrs]
      checkout_params[:order_items_attrs].each do |prms|
        @order_items << OrderItem.new(
          {book_id: prms['book_id'], quantity: prms['quantity']})
      end
    end

    @order = current_order || Order.new(customer: current_customer)

    @order.next_step = 'address' unless @order.next_step
    @order.coupon_id = Coupon.exists?(
      id: checkout_params[:coupon_id]) ? checkout_params[:coupon_id] : nil
    @order.order_items.each { |item| item.destroy }
    @order.order_items = compact_order_items(@order_items)

    @checkout = Checkout.new(@order)
    
    if @checkout.save
      redirect_to checkout_path(@order.next_step.to_sym)
    else
      redirect_to root_path, notice: @checkout.inspect
    end
  end

  def show
    @checkout = Checkout.new(current_order) if current_order
    case step
    when :address
      if @checkout  
        redirect_if_wrong_step(:address) or return
        @checkout.model.billing_address ||= Address.new(
          current_customer.billing_address.attributes)
        @checkout.model.shipping_address ||= Address.new(
          current_customer.shipping_address.attributes)
      end
    when :shipment
      redirect_if_wrong_step(:shipment) or return
    when :payment
      redirect_if_wrong_step(:payment) or return
      @checkout.model.credit_card ||= CreditCard.new if @checkout
    when :confirm
      redirect_if_wrong_step(:confirm) or return
    when :complete
      @checkout = Checkout.new(last_processing_order) if last_processing_order
      redirect_if_wrong_step(:complete) or return
    end
    redirect_if_nil(step, @checkout)
  end  

  def update
    @checkout = Checkout.new(current_order)
    case step
    when :address
      @validation_hash = set_next_step(@checkout.model.next_step, 'shipment')
      @validation_hash = @validation_hash.merge(
          checkout_params['model'])
      @return_hash = { billing_address: @validation_hash['billing_address'], 
                       shipping_address: @validation_hash['shipping_address'] }

      if params['use_billing']
        @validation_hash.merge!(
              {shipping_address: checkout_params['model']['billing_address']})
        @return_hash['shipping_address'] = @validation_hash['billing_address']
      end
    when :shipment
      @validation_hash = set_next_step(@checkout.model.next_step, 'payment')
      @validation_hash = @validation_hash.merge(
        checkout_params['model'])
      @return_hash = {shipping_method: checkout_params['model']['shipping_method'],
        shipping_price: checkout_params['model']['shipping_price']}
    when :payment
      @validation_hash = @checkout.model.attributes.merge(
        {next_step: 'confirm'}.merge(
          checkout_params['model']))
      @return_hash = @validation_hash['credit_card']
    when :confirm
      @validation_hash = @checkout.model.attributes.merge(
        {next_step: 'complete', state: "processing"})
      @return_hash = nil
    end
    save_and_render
  end


  private

    def redirect_if_wrong_step(step)
      next_step = @checkout.model.next_step
      if next_step.nil?
        # if step != :address
        redirect_to order_items_index_path, notice: "Please checkout first" and return
        # end
      elsif next_step.to_sym != step
        redirect_to checkout_path(@checkout.model.next_step.to_sym), notice: "Please proceed checkout from this step" and return
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
        redirect_to root_path, notice: "You have no orders in processing"
      else
        redirect_to root_path, notice: "You have no orders in progress"
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

      params.require(:order).permit(
        :coupon_id,
        model: [:total_price,
                :completed_date,
                :customer_id,
                :state,
                :next_step,
                :shipping_price,
                :shipping_method,
                billing_address: address,
                shipping_address: address,
                credit_card:     [:number, 
                                  :cvv, 
                                  :firstname, 
                                  :lastname,
                                  :expiration_month, 
                                  :expiration_year,
                                  :customer_id]], 
        order_items_attrs: [:book_id, :quantity, :price])
    end
end