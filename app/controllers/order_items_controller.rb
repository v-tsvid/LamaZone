class OrderItemsController < ApplicationController
  include CookiesHandling

  authorize_resource

  # GET /order_items
  def index
    @order = order_with_order_items
    @order_items = @order.order_items

    if !@order || @order_items.empty?
      redirect_to root_path, notice: 'Your cart is empty' 
    end
  end

  def create
    if current_customer
      @order = current_order || Order.new(customer: current_customer)
      @order.order_items << OrderItem.create(
        book_id: params[:book_id], quantity: params[:quantity], order: @order)
      compact_if_not_compacted(@order.order_items)
      redirect_to :back, alert: "Can't add book" and return unless @order.save!
    else
      interact_with_cookies { |order_items| push_to_cookies(order_items) }
    end
    redirect_to :back, notice: "\"#{Book.find(params[:book_id]).title}\" " \
                                   "was added to the cart"
  end

  def destroy
    @order_item = OrderItem.find(params[:id])
    book = @order_item.book
    
    if current_order
      @order = current_order
      @order_item.destroy
      @order.destroy unless @order.order_items[0]
    else
      interact_with_cookies { |order_items| pop_from_cookies(order_items) }
    end
    redirect_to :back, notice: "\"#{book.title}\" " \
                                 "was removed from the cart"

  end

  def delete_from_cookies
    interact_with_cookies { |order_items| pop_from_cookies(order_items) }
    redirect_to :back, notice: "\"#{Book.find(params[:book_id]).title}\" " \
                                   "was removed from the cart"
  end

  private

    def order_with_order_items
      if current_order
        order = current_order
        order.order_items = combine_with_cookies(order.order_items)
      elsif cookies['order_items']
        if current_customer
          order = Order.create(customer: current_customer, state: 'in_progress')
          order.order_items = compact_order_items(read_from_cookies)
          cookies.delete('order_items')
        else
          order = Order.new
          order.order_items = compact_order_items(read_from_cookies)
          order.order_items.each { |item| item.send(:update_price) }
        end
      end
      order || Order.new
    end

    def combine_with_cookies(order_items)
      temp_items = order_items.map { |item| OrderItem.new(item.attributes) }
      order_items.destroy_all
      order_items = compact_order_items(temp_items + read_from_cookies)
      cookies.delete('order_items')

      order_items
    end


    def compact_if_not_compacted(order_items)
      if order_items != compact_order_items(order_items)
        temp_items = order_items
        order_items.each { |item| item.destroy }
        order_items << compact_order_items(temp_items)
      end
    end
end
