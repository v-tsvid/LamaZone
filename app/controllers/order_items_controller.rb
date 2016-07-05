class OrderItemsController < ApplicationController

  authorize_resource

  def index
    @order = order_with_items
    @order_items = @order.order_items

    if @order_items.empty?
      redirect_to root_path, notice: t("controllers.cart_is_empty") 
    end
  end

  def create
    if current_customer
      @order = OrderFiller.new(current_customers_order).add_items_to_order(     
        [OrderItem.order_item_from_params(order_item_params)])
    else
      interact_with_cookies { |order_items| push_to_cookies(order_items) }
    end
    redirect_to :back, notice: "\"#{book_title}\" #{t("controllers.added")}"
  end

  def destroy
    @order_item = OrderItem.find_by_id(params[:id])
    if @order_item
      @order_item.destroy
      current_order.destroy unless current_order.order_items[0]  
      redirect_to(:back, 
        notice: "\"#{@order_item.book.title}\" #{t("controllers.removed")}")
    else
      redirect_to :back, notice: t("controllers.failed_to_remove_book")
    end
  end

  def delete_from_cookies
    interact_with_cookies { |order_items| pop_from_cookies(order_items) }
    redirect_to :back, notice: "\"#{book_title}\" #{t("controllers.removed")}"
  end

  private

    def order_with_items
      order = OrderFiller.new(get_order).add_items_to_order(read_from_cookies)
      cookies.delete('order_items') if order.persisted?
      order
    end

    def get_order
      current_customers_order || Order.new
    end

    def book_title
      Book.find(params[:book_id]).title
    end

    def order_item_params
      params.permit(:book_id, :quantity)
    end
end
