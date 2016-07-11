class CreditCard < ActiveRecord::Base
  belongs_to :customer
  has_many :orders, dependent: :destroy

  def custom_label_method
    "#{self.number}"
  end
end
