module OrderHelpers
  extend ActiveSupport::Concern

  def actualize_cart
    order = OrderFiller.new(current_customers_order || Order.new).
      add_items_to_order(read_from_cookies)
    cookies.delete('order_items') if order.persisted?
    order
  end
  
  def current_order
    current_customer ? current_customer.current_order_of_customer : nil
  end

  def last_order
    current_order || (current_customer ? Order.processing_by_customer(current_customer).last : nil)
  end

  def current_customers_order
    current_order || Order.create_customers_order(current_customer)
  end

  def order_from_cookies
    order = Order.new
    order.order_items = read_from_cookies
    order
  end

  private

    def get_order
      current_customers_order || Order.new
    end
end