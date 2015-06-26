class OrderItem < ActiveRecord::Base
  validates :price, :quantity, presense: true

  belongs_to :book
  belongs_to :order
end
