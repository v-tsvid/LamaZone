class AddressesController < ApplicationController
  before_action :authenticate_customer!
  load_and_authorize_resource

  def create
    if @address.save
      redirect_to edit_customer_registration_path(current_customer), 
        notice: t("controllers.address_created")
    else
      redirect_to :back, {flash: { 
        alert: @address.errors.full_messages.join('. ') }}
    end
  end

  def update
    if @address.update(address_params)
      redirect_to edit_customer_registration_path(current_customer), 
        notice: t("controllers.address_updated")
    else
      redirect_to :back, {flash: { 
        alert: @address.errors.full_messages.join('. ') }} 
    end
  end

  private

    def address_params
      params.require(:address).permit(:phone, 
                                      :address1, 
                                      :address2, 
                                      :city, 
                                      :zipcode, 
                                      :country_id, 
                                      :firstname, 
                                      :lastname,
                                      :billing_address_for_id,
                                      :shipping_address_for_id)
    end
end