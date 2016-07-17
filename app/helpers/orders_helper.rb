module OrdersHelper

  def actual_orders(orders, state)
    orders.where(state: state).reverse_order
  end
end
