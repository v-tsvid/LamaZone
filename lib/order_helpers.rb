module OrderHelpers
  
  def current_order
    current_customer ? current_customer.current_order_of_customer : nil
  end

  def last_order
    current_order || (current_customer ? Order.where(
      customer: current_customer, state: 'processing').last : nil)
  end

  def current_customers_order
    current_order || Order.create_customers_order(current_customer)
  end

  def order_from_cookies
    order = Order.new
    order.order_items = read_from_cookies
    order
  end
end