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

  # def price
  #   book.price
  # end

  private

    def update_price
      self.price = self.book.price * self.quantity
    end

    def custom_label_method
      "#{Book.find(self.book_id).title}"
    end
end
