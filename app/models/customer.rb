class Customer < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :email, :password_digest, presence: true
  validates :password, :password_confirmation, presence: true
  validates :firstname, :lastname, presence: true
  validates :email, format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }

  has_many :orders
  has_many :ratings

  has_secure_password

  before_save { email.downcase! }

  private
  
    def add_order
      orders.new
    end

    def order_in_progress
      orders.in_progress.first
    end
end
