class CreditCard < ActiveRecord::Base
  belongs_to :customer
  has_many :orders

  rails_admin do
    object_label_method do
      :custom_label_method
    end
  end

  private

    def custom_label_method
      "#{self.number}"
    end
end
