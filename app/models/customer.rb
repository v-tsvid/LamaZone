class Customer < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,          
         :omniauthable, :omniauth_providers => [:facebook]
         
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :email, presence: true
  validates :email, format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }

  has_many :orders
  has_many :ratings

  has_one :billing_address, class_name: 'Address', foreign_key: 'billing_address_for_id'
  has_one :shipping_address, class_name: 'Address', foreign_key: 'shipping_address_for_id'

  before_save :downcase_email

  rails_admin do
    object_label_method do
      :custom_label_method
    end
  end

  def full_name
    "#{self.firstname} #{self.lastname}"
  end

  def current_order
    Order.find_by(customer: self, state: 'in_progress') || Order.new(customer: self)
  end

  private

  def custom_label_method
    "#{self.lastname} #{self.firstname}"
  end

  def downcase_email
    self.email.downcase!
  end

  def add_order
    orders.new
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |customer|
      customer.email = auth.info.email
      customer.password = Devise.friendly_token[0,20]
      customer.password_confirmation = customer.password
      customer.firstname = auth.info.first_name
      customer.lastname = auth.info.last_name   
    end
  end
end
