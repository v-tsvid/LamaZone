class AddressesController < ApplicationController
  before_action :authenticate_customer!
  load_and_authorize_resource

  # # # POST /addresses
  # # # POST /addresses.json
  def create
    respond_to do |format|
      if @address.save
        format.html { redirect_to edit_customer_registration_path(current_customer), 
          notice: 'Address was successfully created.' }
        format.json { render :show, status: :created, location: @address }
      else
        format.html { redirect_to :back, {flash: { errors: @address.errors }} }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # # # PATCH/PUT /addresses/1
  # # # PATCH/PUT /addresses/1.json
  def update
    respond_to do |format|
      if @address.update(address_params)
        format.html { 
          redirect_to edit_customer_registration_path(current_customer), 
          notice: 'Address was successfully updated.' }
        format.json { render :show, status: :ok, location: @address }
      else
        format.html { 
          redirect_to :back, {flash: { 
          alert: @address.errors.full_messages.join('. ') }} }
        format.json { 
          render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    # # Never trust parameters from the scary internet, only allow the white list through.
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
