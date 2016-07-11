module OrdersHelper

  def order_completed_date(order)
    DateDecorator.decorate(order.completed_date).date || 
    t("orders_page.not_completed")
  end
end
