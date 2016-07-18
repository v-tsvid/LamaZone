class Customer < ActiveRecord::Base
  include PersonMethods

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,          
         :omniauthable, :omniauth_providers => [:facebook]
         
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :email, presence: true
  validates :email, format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }

  has_many :orders, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_one :credit_card, dependent: :destroy

  has_one :billing_address, class_name: 'Address', foreign_key: 'billing_address_for_id'
  has_one :shipping_address, class_name: 'Address', foreign_key: 'shipping_address_for_id'

  before_save :downcase_email

  def current_order_of_customer
    Order.find_by(customer: self, state: 'in_progress')
  end

  def email_for_facebook
    "#{self.lastname}_#{self.firstname}#{number}@facebook.com"
  end

  class << self

    def by_facebook(auth)
      where(provider: auth.provider, uid: auth.uid)
    end
  end

  private

    def number
      Customer.last ? (Customer.last.id + 1) : 1
    end

    def downcase_email
      self.email.downcase!
    end
end
