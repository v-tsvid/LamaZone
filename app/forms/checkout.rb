class Checkout < Reform::Form

  property :total_price
  property :completed_date
  property :state
  property :customer
  property :credit_card
  property :shipping_address
  property :billing_address
  property :next_step

  collection :order_items do
    property :price
    property :quantity
    property :book 
    property :order

    validates :price, :quantity, :book, presence: true
    validates :order, presence: true, unless: :on_address_step?
    validates :price, numericality: { greater_than: 0 }
    validates :quantity, numericality: { only_integer: true,
                                         greater_than: 0 }
  end

  validates :total_price, 
            :completed_date, 
            :customer,  
            :state, 
            :order_items,
            :next_step, 
            presence: true
  
  validates :total_price, numericality: { greater_than: 0 }, unless: :on_address_step?
  validates :credit_card, presence: true, unless: :on_address_step? || :on_delivery_step?
  validates :billing_address, :shipping_address, presence: true, unless: :on_address_step?

  def persisted?
    false
  end

  def save
    super
    model.save
  end

  private

  # def persist!

  #   # order_items.each do |item|
  #   #   OrderItem.create!(item)
  #   # end

  #   @order = Order.create!(
  #     total_price: total_price,
  #     completed_date: completed_date,
  #     customer: customer,
  #     credit_card: credit_card,
  #     shipping_address: shipping_address,
  #     billing_address: billing_address,
  #     state: state,
  #     next_step: next_step,
  #     order_items: order_items)

  #   # @order_items = Array.new


  #   # @order.order_items << order_items

  #   @order.save!

  # end

  def on_address_step?
    self.next_step == 'address' ? true : false
  end

  def on_delivery_step?
    self.next_step == 'delivery' ? true : false
  end
end