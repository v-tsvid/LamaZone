class Address < ActiveRecord::Base

  validates :firstname, :lastname, :phone, :address1, presence: true
  validates :city, :zipcode, :country_id, presence: true
  
  # provided by phony_rails gem
  # validates phone number to be correct and plausible 
  # without country accordance
  validates :phone, phony_plausible: { ignore_record_country_code: true }
  
  # provided by validates_zipcode gem
  # validates zipcode to be correct due to country alpha2 code
  validates :zipcode, zipcode: { country_code: :country_code }

  belongs_to :country
  belongs_to :customer_billing, class_name: 'Customer', 
    primary_key: 'billing_address_for_id'
  belongs_to :customer_shipping, class_name: 'Customer', 
    primary_key: 'shipping_address_for_id'
  
  before_save :normalize_phone

  def attributes_short
    self.attributes.except('created_at', 
                           'updated_at', 
                           'id', 
                           'billing_address_for_id', 
                           'shipping_address_for_id')
  end

  private

    def normalize_phone
      # provided by phony gem
      # delete all characters excepting digits
      Phony.normalize!(self.phone)
    end

    def country_code
      Country.find(self.country_id).alpha2
    end
end
