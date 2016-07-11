class Customers::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @customer = Customer.from_omniauth(request.env["omniauth.auth"])

    @customer.email = generated_email(@customer) if !@customer.email
     

    if @customer.save
      sign_in_and_redirect @customer, event: :authentication 
      set_flash_message(:notice, :success, 
                        kind: "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"] 
      redirect_to root_path
      set_flash_message(:notice, :failure, kind: "Facebook", 
        reason: "#{@customer.inspect}") if is_navigational_format?
    end
  end

  private

    def generated_email(customer)
      "#{customer.lastname}_#{customer.firstname}#{number}@facebook.com"
    end

    def number
      Customer.last ? (Customer.last.id + 1) : 1
    end
  # You should configure your model like this:
  # devise :omniauthable, omniauth_providers: [:twitter]

  # You should also create an action method in this controller like this:
  # def twitter
  # end

  # More info at:
  # https://github.com/plataformatec/devise#omniauth

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # GET|POST /users/auth/twitter/callback
  # def failure
  #   super
  # end

  # protected

  # The path used when OmniAuth fails
  # def after_omniauth_failure_path_for(scope)
  #   super(scope)
  # end
end
