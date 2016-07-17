class OrdersController < ApplicationController

  load_and_authorize_resource only: [:index, :show]
  authorize_resource only: [:update, :destroy]

  def index
  end

  def show
  end

  def update
    current_order.order_items.destroy_all
    items = OrderItem.order_items_from_order_params order_params
    @order = OrderFiller.new(current_order).add_items_to_order items

    @order_items = @order.order_items
  
    redirect_to cart_path
  end

  def update_cookies
    @order_items = OrderItem.order_items_from_order_params order_params
    write_to_cookies @order_items 

    redirect_to cart_path
  end

  def destroy
    @order = current_order
    @order.destroy

    redirect_to cart_path
  end

  def destroy_cookies
    cookies.delete('order_items')

    redirect_to cart_path
  end

  private

    def order_params
      params.permit(order_items_attrs: [:book_id, :quantity])
    end
end
