class Customers::RegistrationsController < Devise::RegistrationsController
before_filter :configure_sign_up_params, only: [:create]
before_filter :configure_account_update_params, only: [:update]
before_filter :assign_addresses, only: [:edit, :update]

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
    super
  end

  # PUT /resource
  def update  
    super
  end

  # DELETE /resource
  def destroy
    if params[:confirm] == '1'
      super 
    else
      redirect_to(
        :back, notice: t("controllers.confirm_risks"))
    end
  end

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
      address = [:firstname, 
                 :lastname, 
                 :phone, 
                 :address1, 
                 :address2, 
                 :city, 
                 :zipcode, 
                 :country_id,
                 :billing_address_for_id,
                 :shipping_address_for_id]

      [:firstname,
       :lastname,
       :email, 
       :password, 
       :password_confirmation, 
       :current_password, 
       billing_address: address,
       shipping_address: address]
    end

    def configure_sign_up_params
      configure_params(:sign_up)
    end

    # If you have extra params to permit, append them to the sanitizer.
    def configure_account_update_params
      configure_params(:account_update)
    end

    def update_resource(resource, params)
      if params[:email] && !params[:current_password]
        resource.update_without_password(params)
      else
        super
      end
    end

  private

    def configure_params(sym)
      devise_parameter_sanitizer.for(sym) do |u| 
        u.permit(params_to_permit)
      end       
    end

    def assign_addresses
      @billing_address = resource.billing_address || Address.new(
        billing_address_for_id: resource.id)
      @shipping_address = resource.shipping_address || Address.new(
        shipping_address_for_id: resource.id)
    end
end
