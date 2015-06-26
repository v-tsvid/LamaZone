class Address < ActiveRecord::Base
  validates :phone, :address1, :address2, presense: true
  validates :city, :zipcode, :country, presense: true
end
