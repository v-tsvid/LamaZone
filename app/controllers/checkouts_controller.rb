class CheckoutsController < ApplicationController
  include Wicked::Wizard

  steps :address, :delivery, :payment, :confirm, :complete

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
    end
    render_wizard
  end  

  def update
    @order = current_order
    @checkout = Checkout.new(@order)
    case step
    when :address
      # @billing_address = Address.new(checkout_params['model']['billing_address'])
      # @order.assign_attributes({next_step: 'delivery'})
      # if @billing_address.save
      #   @order.assign_attributes({billing_address_id: @billing_address.id})
      #   @order.assign_attributes({shipping_address_id: @billing_address.id}) if params['use_billing']
      # end
      # @checkout.model.billing_address = Address.new
      # @checkout.model.shipping_address = Address.new
      # @checkout.model.billing_address.assign_attributes(
      #   checkout_params['model']['billing_address'])
      # @checkout.model.shipping_address.assign_attributes(
      #   checkout_params['model']['billing_address']) if params['use_billing']
      # @checkout.model.assign_attributes({next_step: 'delivery'})

      @validation_hash = @order.attributes.merge(
        {next_step: 'delivery'}.merge(
          checkout_params['model'].merge(
            {shipping_address: checkout_params['model']['billing_address']})))

      if @checkout.validate(@validation_hash)
        render_wizard @checkout
      else
        redirect_to :back, {flash: { errors: @checkout.errors}} 
      end
    end
  end


  private 

  def checkout_params
    params.require(:order).permit(
      model: [:total_price,
              :completed_date,
              :customer_id,
              :credit_card,
              :state,
              :next_step,
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