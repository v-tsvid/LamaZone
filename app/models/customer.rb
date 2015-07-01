class Customer < ActiveRecord::Base
  validates :email, :password, :password_confirmation, presence: true
  validates :firstname, :lastname, presence: true
  validates :email, uniqueness: true

  has_many :orders
  has_many :ratings
  
  def add_order
    orders.new
  end

  def order_in_progress
    orders.in_progress.first
  end
end
