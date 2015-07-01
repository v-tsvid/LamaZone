class Order < ActiveRecord::Base
  validates :total_price, :completed_date, :state, presence: true

  belongs_to :customer
  belongs_to :credit_card
  has_many :order_items
  belongs_to :billing_address, :class_name => 'Address', :foreign_key => 'billing_address_id'
  belongs_to :shipping_address, :class_name => 'Address', :foreign_key => 'shipping_address_id'

  scope :in_progress, -> { where(state: 0) }

  def add_book(book_id)
    item = order_items.where(book_id: book_id).first
    item.quantity += 1
    item.save
  end
end
