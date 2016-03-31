class CheckoutsController < ApplicationController
  include Wicked::Wizard

  steps :address, :shipping, :payment, :confirm, :complete

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
      redirect_to :back, notice: @checkout.inspect
    end
  end

  def show
    @checkout = Checkout.new(current_order)
    case step
    when :address
      @checkout.model.billing_address ||= Address.new
    when :shipping
    end
    render_wizard
  end  

  def update
    @checkout = Checkout.new(current_order)
    case step
    when :address
      @validation_hash = @checkout.model.attributes.merge(
        {next_step: 'shipping'}.merge(
          checkout_params['model'].merge(
            {shipping_address: checkout_params['model']['billing_address']})))
      @return_hash = @validation_hash['billing_address']

      save_and_render
    when :shipping
      @validation_hash = @checkout.model.attributes.merge(
        {next_step: 'payment'}.merge(
          checkout_params['model']))
      @return_hash = {shipping_method: checkout_params['model']['shipping_method'],
        shipping_price: checkout_params['model']['shipping_price']}

      save_and_render
    end
  end


  private 

    def save_and_render
      if @checkout.validate(@validation_hash)
        render_wizard @checkout
      else
        redirect_to :back, {flash: { 
          errors: @checkout.errors, attrs: @return_hash } } 
      end 
    end

    def checkout_params
      params.require(:order).permit(
        model: [:total_price,
                :completed_date,
                :customer_id,
                :credit_card,
                :state,
                :next_step,
                :shipping_price,
                :shipping_method,
                billing_address: [:firstname,
                                  :lastname,
                                  :address1,
                                  :address2,
                                  :phone,
                                  :city,
                                  :zipcode,
                                  :country_id,
                                  :billing_address_for_id,
                                  :shipping_address_for_id],
                shipping_address: [:firstname,
                                  :lastname,
                                  :address1,
                                  :address2,
                                  :phone,
                                  :city,
                                  :zipcode,
                                  :country_id,
                                  :billing_address_for_id,
                                  :shipping_address_for_id]], 
        order_items_attrs: [:book_id, :quantity, :price])
    end
end