class Order < ActiveRecord::Base
  validates :total_price, :completed_date, :state, presence: true
  validates :state

  belongs_to :customer
  belongs_to :credit_card
  has_many :order_items
  belongs_to :billing_address, :class_name => 'Address', :foreign_key => 'billing_address_id'
  belongs_to :shipping_address, :class_name => 'Address', :foreign_key => 'shipping_address_id'

  def add_book
  end

  def total_price
  end
end
