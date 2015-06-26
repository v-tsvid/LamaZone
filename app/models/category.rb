class Category < ActiveRecord::Base
  validates :title, presense: true, uniqueness: true

  has_many :books
end
