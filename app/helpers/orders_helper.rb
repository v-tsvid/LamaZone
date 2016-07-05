module OrdersHelper

  def order_completed_date(order)
    DateDecorator.new(order.completed_date).decorate || 
    t("orders_page.not_completed")
  end
end
