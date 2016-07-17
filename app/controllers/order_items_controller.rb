class OrderItemsController < ApplicationController

  authorize_resource

  def index
    @order = OrderFiller.new(get_order).add_items_to_order(read_from_cookies)
    cookies.delete('order_items') if @order.persisted?

    @order_items = @order.order_items

    if @order_items.empty?
      @order.destroy
      redirect_to root_path, notice: t("controllers.cart_is_empty") 
    end
  end

  def create
    if current_customer
      items = [OrderItem.order_item_from_params(order_item_params)]
      @order = OrderFiller.new(current_customers_order).add_items_to_order items

    else
      interact_with_cookies { |order_items| push_to_cookies(order_items) }
    end
    redirect_to :back, notice: "\"#{Book.title_by_id(params[:book_id])}\" "\
                               "#{t("controllers.added")}"
  end

  def destroy
    @order_item = OrderItem.find_by_id(params[:id])
    if @order_item
      @order_item.destroy
      current_order.destroy unless current_order.order_items[0]  
      notice = "\"#{@order_item.book.title}\" #{t("controllers.removed")}"
    else
      notice = t("controllers.failed_to_remove_book")
    end
    redirect_to :back, notice: notice
  end

  def delete_from_cookies
    interact_with_cookies { |order_items| pop_from_cookies(order_items) }
    redirect_to :back, notice: "\"#{Book.title_by_id(params[:book_id])}\" "\
                               "#{t("controllers.removed")}"
  end

  private

    def get_order
      current_customers_order || Order.new
    end

    def order_item_params
      params.permit(:book_id, :quantity)
    end
end
