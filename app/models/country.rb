class Country < ActiveRecord::Base
  VALID_ALPHA2_REGEX = /\A[A-Z]{2}\z/
  INVALID_ALPHA2_REGEX_MESSAGE = "allow only two capitals"
  
  validates :name, :alpha2, presence: true, uniqueness: true
  validates :alpha2, format: { with: VALID_ALPHA2_REGEX, 
    message: INVALID_ALPHA2_REGEX_MESSAGE }
end
