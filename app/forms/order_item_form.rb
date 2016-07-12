class OrderItemForm< Reform::Form
  model :order_item

  property :price
  property :quantity
  property :book 
  property :order

  validates :price, :quantity, :book, presence: true
  validates :order, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :quantity, numericality: { only_integer: true,
                                       greater_than: 0 }
end