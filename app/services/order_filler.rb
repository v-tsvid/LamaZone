class OrderFiller
  def initialize(order)
    @order = order
  end

  def add_items_to_order(items_to_add)
    @order.order_items = OrderItem.combine_order_items(
      @order.order_items, items_to_add)

    @order
  end
end