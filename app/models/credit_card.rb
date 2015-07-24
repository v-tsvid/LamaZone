class CreditCard < ActiveRecord::Base
  VALID_EXP_MONTH_REGEX = /\A([0][1-9]|[1][0-2])\z/
  VALID_EXP_YEAR_REGEX = /\A[2][0]([1][5-9]|[2][0-9])\z/
  VALID_CVV_REGEX = /\A[0-9]{3,4}\z/

  INVALID_MESSAGE = "is not valid"
  EXPIRED_MESSAGE = "is expired"

  validates :number, :cvv, :firstname, :lastname, presence: true
  validates :expiration_month, :expiration_year, presence: true
  validates :expiration_month, format: { with: VALID_EXP_MONTH_REGEX, 
    message: INVALID_MESSAGE }
  validates :expiration_year, format: { with: VALID_EXP_YEAR_REGEX, 
    message: INVALID_MESSAGE }
  validates :cvv, format: { with: VALID_CVV_REGEX, message: INVALID_MESSAGE }

  validate :validate_number, :validate_exp_date
  
  belongs_to :customer
  has_many :orders

  private

    def validate_number
      # CreditCardValidator::Validator.valid? 
      # is provided by credit_card_validator gem
      errors.add(:number, INVALID_MESSAGE) unless 
        self.number && CreditCardValidator::Validator.valid?(self.number)
    end

    def validate_exp_date
      errors[:base] << EXPIRED_MESSAGE unless 
        self.expiration_month && self.expiration_year && 
        (self.expiration_year > Date.today.strftime("%Y") || 
          self.expiration_year == Date.today.strftime("%Y") &&
          self.expiration_month >= Date.today.strftime("%m"))
    end
end
