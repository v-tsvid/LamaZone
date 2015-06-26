class Customer < ActiveRecord::Base
  validates :email, :password, :password_confirmation, presence: true
  validates :firstname, :lastname, presence: true
  validates :email, uniqueness: true

  has_many :orders
  has_many :ratings

  def add_order
  end

  def order_in_progress
  end
end
