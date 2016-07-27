class Customers::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  after_action :actualize_cart
  
  def facebook
    @customer = OmniauthAuthorizer.new(request.env["omniauth.auth"]).authorize
    
    if @customer && @customer.save
      sign_in_and_redirect @customer, event: :authentication 
      set_flash_message(:notice, :success, 
                        kind: "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"] 
      redirect_to new_customer_registration_path
      set_flash_message(:notice, :failure, kind: "Facebook", 
        reason: t("facebook_authorize_failure")) if is_navigational_format?
    end
  end
end
