class CartDecorator < BaseDecorator
  
  def cart_subtotal

  end

  def decorate
    second_part = 
    if calc_total_quantity == 0
      "(#{I18n.t :is_empty})"
    else 
      "(#{calc_total_quantity}) " \
      "#{PriceDecorator.new(calc_subtotal).decorate}"
    end

    "#{I18n.t :cart}: " + second_part
  end

  private

    def calc_subtotal
      @obj.order_items.each { |item| item.send(:update_price)}
      @obj.send(:update_subtotal)
    end

    def calc_total_quantity
      @obj.order_items.collect { |item| item.quantity }.sum
    end
end