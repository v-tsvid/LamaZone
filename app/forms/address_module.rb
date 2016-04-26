module AddressModule
  include Reform::Form::Module

  property :firstname
  property :lastname
  property :address1
  property :address2
  property :phone
  property :city
  property :zipcode
  property :country_id
  property :billing_address_for_id
  property :shipping_address_for_id

  validates :firstname,
            :lastname,
            :address1,
            :phone,
            :city,
            :zipcode,
            :country_id,
            presence: true

  # provided by phony_rails gem
  # validates phone number to be correct and plausible 
  # without country accordance
  validates :phone, phony_plausible: { ignore_record_country_code: true }

  # provided by validates_zipcode gem
  # validates zipcode to be correct due to country alpha2 code
  validates :zipcode, zipcode: { country_code: :country_code }
end