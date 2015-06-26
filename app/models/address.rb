class Address < ActiveRecord::Base
  validates :phone, :address1, :address2, presence: true
  validates :city, :zipcode, :country, presence: true
end
