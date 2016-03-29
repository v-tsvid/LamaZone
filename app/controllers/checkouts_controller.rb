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
      @billing_address = current_customer.billing_address
      @shipping_address = current_customer.shipping_address
    end
    render_wizard
  end  

  def update
  end


  private 

  def checkout_params
    params.require(:checkout).permit(
      order: [:total_price,
              :completed_date,
              :customer_id,
              :credit_card,
              :billing_address,
              :shipping_address,
              :state,
              :next_step], 
      order_items_attrs: [:book_id, :quantity, :price])
  end
end