module OrdersHelper

  def actual_orders(orders, state)
    orders.by_state(state).reverse_order
  end
end
