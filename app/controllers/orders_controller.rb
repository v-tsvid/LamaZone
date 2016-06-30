class OrdersController < ApplicationController
  include CookiesHandling

  load_and_authorize_resource only: [:index, :show]
  authorize_resource except: [:index, :show]

  def index
  end

  def show
  end

  def update
    @order = current_order
    @order.order_items.destroy_all
    @order_items = current_order_items_from_params
  
    redirect_to order_items_path
  end

  def update_cookies
    @order_items = order_items_from_params
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

    def current_order_items_from_params
      order_params[:order_items_attrs].map do |item|
        OrderItem.create(book_id:  item[:book_id], 
                         quantity: item[:quantity], 
                         order:    current_order)
      end
    end

    def order_items_from_params
      order_params[:order_items_attrs].map do |item|
        OrderItem.new(book_id: item[:book_id], quantity: item[:quantity])
      end
    end

    def order_params
      params.permit(order_items_attrs: [:book_id, :quantity])
    end
end
