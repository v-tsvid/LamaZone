class OmniauthAuthorizer
  def initialize(auth)
    @auth = auth
  end

  def authorize
    info = @auth.info

    if info
      Customer.by_facebook(@auth).first_or_create do |customer|
        customer.firstname = info.first_name
        customer.lastname = info.last_name
        customer.email = info.email || customer.email_for_facebook
        customer.password = Devise.friendly_token[0,20]
        customer.password_confirmation = customer.password
      end
    end
  end
end