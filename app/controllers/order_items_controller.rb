class OrderItemsController < ApplicationController
  include CookiesHandling

  def update_cart
    if current_order
      current_order.order_items.destroy_all
      @order_items = current_order_items_from_params
    else
      @order_items = order_items_from_params
      write_to_cookies(@order_items)
    end
    redirect_to order_items_path
  end

  def empty_cart
    if current_order
      current_order.order_items.destroy_all
      current_order.destroy
    else
      cookies.delete('order_items')
    end
    redirect_to order_items_path
  end

  def add_to_cart
    if current_customer
      order = current_order || Order.new(customer: current_customer)
      order.order_items << OrderItem.create(
        book_id: params[:book_id], quantity: params[:quantity], order: order)
      compact_if_not_compacted(order.order_items)
      redirect_to :back, alert: "Can't add book" and return unless order.save!
    else
      interact_with_cookies { |order_items| push_to_cookies(order_items) }
    end
    redirect_to :back, notice: "\"#{Book.find(params[:book_id]).title}\" " \
                                   "was added to the cart"
  end

  def remove_from_cart
    if current_order
      order = current_order
      item = OrderItem.find_by(order_id: current_order.id, 
        book_id: params[:book_id]).destroy
      order.destroy unless order.order_items[0]
    else
      interact_with_cookies { |order_items| pop_from_cookies(order_items) }
    end
    redirect_to :back, notice: "\"#{Book.find(params[:book_id]).title}\" " \
                                 "was removed from the cart"
  end

  # GET /order_items
  # GET /order_items.json
  def index
    @order = order_with_order_items

    if !@order || @order.order_items.empty?
      redirect_to root_path, notice: 'Your cart is empty' 
    end
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

    def current_order_items_from_params
      order_items_params[:order_items_attrs].map do |item|
        OrderItem.create(book_id:  item[:book_id], 
                         quantity: item[:quantity], 
                         order:    current_order)
      end
    end

    def order_items_from_params
      order_items_params.map do |item|
        OrderItem.new(book_id: item[:book_id], quantity: item[:quantity])
      end
    end

    def order_items_params
      params.permit(order_items_attrs: [:book_id, :quantity])
    end
end
