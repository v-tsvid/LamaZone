class OrderItem < ActiveRecord::Base
  before_validation :update_price

  validates :price, :quantity, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :quantity, numericality: { only_integer: true,
                                       greater_than_or_equal_to: 0 }

  belongs_to :book
  belongs_to :order

  def custom_label_method
    "#{Book.find(self.book_id).title}"
  end

  class << self

    def order_item_from_params(params)
      new(book_id: params[:book_id], quantity: params[:quantity])
    end

    def order_items_from_order_params(order_params)
      order_params[:order_items_attrs].map do |params|
        order_item_from_params(params)
      end
    end

    def combine_order_items(items, items_to_add)
      temp_items = items.map { |item| OrderItem.new(item.attributes) }
      items = OrderItem.compact_order_items(temp_items + items_to_add)

      items
    end

    def compact_order_items(items)
      items = grouped(items).map do |item| 
        OrderItem.new(book_id: item.first.book_id, 
                      quantity: total_quantity(item))
      end
      get_prices_from_books(items)
    end

    private 

      def grouped(items)
        items.group_by{|gr_item| gr_item.book_id}.values
      end

      def total_quantity(item)
        item.inject(0){|sum, inj| sum + inj.quantity}
      end

      def get_prices_from_books(order_items)
        order_items.each do |item| 
          item.price = item.book.price * item.quantity
        end
      end
  end

  private

    def update_price
      self.price = self.book.price * self.quantity
    end
end
