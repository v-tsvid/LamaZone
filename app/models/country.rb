class Country < ActiveRecord::Base
  validates :name, presense: true, uniqueness: true
end
