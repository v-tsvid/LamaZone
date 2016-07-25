class CreditCard < ActiveRecord::Base
  belongs_to :customer
  has_many :orders, dependent: :destroy
end
