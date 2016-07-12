class Customers::RegistrationsController < Devise::RegistrationsController
before_filter :configure_sign_up_params, only: [:create]
before_filter :configure_account_update_params, only: [:update]
before_filter :assign_addresses, only: [:edit, :update]

  def destroy
    if params[:confirm] == '1'
      super 
    else
      redirect_to(
        :back, notice: t("controllers.confirm_risks"))
    end
  end

  protected

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
      @billing_address = assign_address('billing')
      @shipping_address = assign_address('shipping')
    end

    def assign_address(str)
      resource.public_send("#{str}_address".to_sym) ||
      Address.new("#{str}_address_for_id" => resource.id)
    end
end
