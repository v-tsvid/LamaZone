class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,          
         :omniauthable, :omniauth_providers => [:facebook]

         
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  validates :email, presence: true
  validates :password, :password_confirmation, presence: true
  validates :firstname, :lastname, presence: true
  validates :email, format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 }

  has_many :orders
  has_many :ratings

  before_save :downcase_email

  rails_admin do
    object_label_method do
      :custom_label_method
    end
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

    def order_in_progress
      orders.in_progress.first
    end

    def self.from_omniauth(auth)
      where(provider: auth.provider, uid: auth.uid).first_or_create do |customer|
        customer.email = auth.info.email
        customer.password = Devise.friendly_token[0,20]
        customer.password_confirmation = customer.password
        customer.firstname = auth.info.first_name
        customer.lastname = auth.info.last_name   
         # customer.image = auth.info.image # assuming the customer model has an image
      end
    end
end
