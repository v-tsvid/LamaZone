class OrdersController < ApplicationController
  include CookiesHandling

  load_and_authorize_resource only: [:index, :show]
  authorize_resource except: [:index, :show]

  def index
  end

  def show
  end

  def update
    current_order.order_items.destroy_all
    @order = OrderFiller.new(current_order).add_items_to_order(
      OrderItem.order_items_from_order_params(order_params))
    @order_items = @order.order_items
  
    redirect_to order_items_path
  end

  def update_cookies
    @order_items = OrderItem.order_items_from_order_params(order_params)
    write_to_cookies(@order_items)

    redirect_to order_items_path
  end

  def destroy
    @order = current_order
    @order.destroy

    redirect_to order_items_path
  end

  def destroy_cookies
    cookies.delete('order_items')

    redirect_to order_items_path
  end

  private

    def order_params
      params.permit(order_items_attrs: [:book_id, :quantity])
    end
end
