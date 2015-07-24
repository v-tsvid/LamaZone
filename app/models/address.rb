class Address < ActiveRecord::Base

  validates :phone, :address1, presence: true
  validates :city, :zipcode, presence: true
  
  # provided by phony_rails gem
  # validates phone number to be correct and plausible 
  # without country accordance
  validates :phone, phony_plausible: { ignore_record_country_code: true }
  
  # provided by validates_zipcode gem
  # validates zipcode to be correct due to country alpha2 code
  validates :zipcode, zipcode: { country_code: :country_code }

  belongs_to :country

  before_save :normalize_phone

  private

    def normalize_phone
      # provided by phony_rails gem
      # delete all characters expecting digits
      Phony.normalize!(self.phone)
    end

    def country_code
      Country.find(self.country_id).alpha2
    end
end
