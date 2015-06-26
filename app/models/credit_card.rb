class CreditCard < ActiveRecord::Base
  validates :number, :cvv, :firstname, :lastname, presense: true
  validates :expiration_month, :expiration_year, presense: true
  
  belongs_to :customer
  has_many :orders
end
