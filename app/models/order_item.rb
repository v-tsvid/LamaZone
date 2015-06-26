class OrderItem < ActiveRecord::Base
  validates :price, :quantity, presence: true

  belongs_to :book
  belongs_to :order
end
