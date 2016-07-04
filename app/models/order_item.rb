class OrderItem < ActiveRecord::Base
  before_validation :update_price

  validates :price, :quantity, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :quantity, numericality: { only_integer: true,
                                       greater_than_or_equal_to: 0 }

  belongs_to :book
  belongs_to :order

  rails_admin do
    object_label_method do
      :custom_label_method
    end
  end

  class << self

    def add_items_to_order(order, items_to_add)
      order.order_items = combine_order_items(
        order.order_items, items_to_add)
      order
    end

    def item_from_params(params)
      OrderItem.new(book_id: params[:book_id], quantity: params[:quantity])
    end

    def current_order_items_from_order_params(order_params, current_order)
      order_params[:order_items_attrs].map do |params|
        current_order.order_items << item_from_params(params)
      end
    end

    def order_items_from_order_params(order_params)
      order_params[:order_items_attrs].map do |params|
        item_from_params(params)
      end
    end

    def compact_order_items(order_items)
      order_items = order_items.group_by{|h| h.book_id}.values.map do |a| 
        OrderItem.new(book_id: a.first.book_id, 
                      quantity: a.inject(0){|sum,h| sum + h.quantity})
      end
      
      order_items.each do |item| 
        item.price = item.book.price
      end

      order_items
    end

    private 

      def combine_order_items(items1, items2)
        temp_items = items1.map { |item| OrderItem.new(item.attributes) }
        items1.destroy_all
        items1 = OrderItem.compact_order_items(temp_items + items2)

        items1
      end

      def compact_if_not_compacted(order_items)
        if order_items != self.compact_order_items(order_items)
          temp_items = order_items
          order_items.each { |item| item.destroy }
          order_items << self.compact_order_items(temp_items)
        end
      end
  end

  private

    def update_price
      self.price = self.book.price * self.quantity
    end

    def custom_label_method
      "#{Book.find(self.book_id).title}"
    end
end
