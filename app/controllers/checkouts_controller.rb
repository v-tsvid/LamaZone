class CheckoutsController < ApplicationController
  include Wicked::Wizard

  steps :address, :shipment, :payment, :confirm, :complete

  def new
    @checkout = Checkout.new(Order.new)
  end

  def create
    @order_items = Array.new
    
    if checkout_params[:order_items_attrs]
      checkout_params[:order_items_attrs].each do |prms|
        @order_items << OrderItem.new(prms)
      end
    end

    @order = current_order || Order.new(customer: current_customer)

    @order.next_step = 'address'

    @temp_items = @order.order_items + @order_items
    @order.order_items.each { |item| item.destroy }
    @order.order_items = compact_order_items(@temp_items)

    @checkout = Checkout.new(@order)
    
    if @checkout.save
      redirect_to checkout_path(:address)
    else
      redirect_to root_path, notice: @checkout.inspect
    end
  end

  def show
    @checkout = Checkout.new(current_order) if current_order
    case step
    when :address
      if @checkout
        @checkout.model.billing_address ||= Address.new
        @checkout.model.shipping_address ||= Address.new
      end
    when :shipment
    when :payment
      @checkout.model.credit_card ||= CreditCard.new if @checkout
    when :confirm
    when :complete
      @checkout = Checkout.new(last_processing_order) if last_processing_order
    end
    redirect_if_nil(step, @checkout)
  end  

  def update
    @checkout = Checkout.new(current_order)
    case step
    when :address
      @validation_hash = @checkout.model.attributes.merge(
          {next_step: 'shipment'}.merge(
            checkout_params['model']))
      @return_hash = { billing_address: @validation_hash['billing_address'], 
                       shipping_address: @validation_hash['shipping_address'] }

      if params['use_billing']
        @validation_hash.merge!(
              {shipping_address: checkout_params['model']['billing_address']})
        @return_hash['shipping_address'] = @validation_hash['billing_address']
      end

      save_and_render
    
    when :shipment
      @validation_hash = @checkout.model.attributes.merge(
        {next_step: 'payment'}.merge(
          checkout_params['model']))
      @return_hash = {shipping_method: checkout_params['model']['shipping_method'],
        shipping_price: checkout_params['model']['shipping_price']}

      save_and_render

    when :payment
      @validation_hash = @checkout.model.attributes.merge(
        {next_step: 'confirm'}.merge(
          checkout_params['model']))
      @return_hash = @validation_hash['credit_card']

      save_and_render

    when :confirm
      @validation_hash = @checkout.model.attributes.merge(
        {next_step: 'complete', state: "processing"})
      @return_hash = nil

      save_and_render
    end
  end


  private
    # def render_or_redirect(current_step)
    #   if @checkout.model.next_step == 
    # end

    def save_and_render
      if @checkout.validate(@validation_hash)
        render_wizard @checkout, notice: params
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