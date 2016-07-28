module OrdersHelper

  def actual_orders(orders, state)
    orders.public_send(state.to_sym).reverse_order
  end
end
