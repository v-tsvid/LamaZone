class OrderSummary
  def initialize(order)
    @order = order
    @coupon = @order.coupon if @order
  end

  def discount
    {tag: "#{tag("discount")}: ", price: "#{@coupon ? @coupon.discount : 0}%"}
  end

  [:subtotal, :shipping_price, :total_price].each do |item|
    define_method item do
      {tag: "#{tag(item.to_s)}: ", price: "#{price(item)}"}
    end
  end

  private

    def tag(str)
      I18n.t("checkout.order.#{str}")
    end

    def price(sym)
      PriceDecorator.decorate(@order.public_send(sym)).price
    end
end