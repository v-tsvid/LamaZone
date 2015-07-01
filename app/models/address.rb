class Address < ActiveRecord::Base
  validates :phone, :address1, :address2, presence: true
  validates :city, :zipcode, presence: true

  belongs_to :country
end
