class Customers::RegistrationsController < Devise::RegistrationsController
before_filter :configure_sign_up_params, only: [:create]
before_filter :configure_account_update_params, only: [:update]

  # # GET /resource/sign_up
  # def new
  #   super
  # end

  # # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  def edit
    resource.build_billing_address unless resource.billing_address
    resource.build_shipping_address unless resource.shipping_address
    super
  end

  # # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def params_to_permit
    [:firstname,
     :lastname,
     :email, 
     :password, 
     :password_confirmation, 
     :current_password, 
     billing_address_attributes: [:firstname, 
                                  :lastname, 
                                  :phone, 
                                  :address1, 
                                  :address2, 
                                  :city, 
                                  :zipcode, 
                                  :country_id], 
     shipping_address_attributes: [:firstname, 
                                   :lastname, 
                                   :phone, 
                                   :address1, 
                                   :address2, 
                                   :city, 
                                   :zipcode, 
                                   :country_id]]
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) do |u| 
      u.permit(params_to_permit)
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.for(:account_update) do |u| 
      u.permit(params_to_permit)
    end
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
