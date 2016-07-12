class Customers::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @customer = Customer.from_omniauth(request.env["omniauth.auth"])

    @customer.email = @customer.email_for_facebook if !@customer.email
     
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
end
