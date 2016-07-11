class OrderDecorator < Draper::Decorator
 
  def number
    "R%09d" % object.id
  end

  def cart_caption
    second_part = 
    if calc_total_quantity == 0
      "(#{I18n.t :is_empty})"
    else 
      "(#{calc_total_quantity}) " \
      "#{PriceDecorator.decorate(calc_subtotal).price}"
    end

    "#{I18n.t :cart}: " + second_part
  end

  private

    def calc_subtotal
      object.order_items.each { |item| item.send(:update_price)}
      object.send(:update_subtotal)
    end

    def calc_total_quantity
      object.order_items.collect { |item| item.quantity }.sum
    end
end