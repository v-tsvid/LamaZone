class AddressesController < ApplicationController
  before_action :set_address, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_customer!
  
  # load_and_authorize_resource
  # skip_load_resource only: [:addresses]

  # # GET /addresses/1
  # # GET /addresses/1.json
  # def show
  # end

  # GET /addresses/new
  def new
    @customer_bil = Customer.find(params[:billing_address_for_id]) if params[:billing_address_for_id]
    @customer_ship = Customer.find(params[:shipping_address_for_id]) if params[:shipping_address_for_id]
    @address = Address.new(
      billing_address_for_id: @customer_bil.to_param, 
      shipping_address_for_id: @customer_ship.to_param)

    # redirect_to edit_customer_registration_path(current_customer)
  end

  # GET /addresses/1/edit
  def edit
  end

  # # POST /addresses
  # # POST /addresses.json
  def create
    @address = Address.new(address_params)

    respond_to do |format|
      if @address.save
        format.html { redirect_to edit_customer_registration_path(current_customer), notice: 'Address was successfully created.' }
        format.json { render :show, status: :created, location: @address }
      else
        format.html { render :new, locals: { customer_id: @customer.id } }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # # PATCH/PUT /addresses/1
  # # PATCH/PUT /addresses/1.json
  def update
    respond_to do |format|
      if @address.update(address_params)
        format.html { redirect_to edit_customer_registration_path(current_customer), notice: 'Address was successfully updated.' }
        format.json { render :show, status: :ok, location: @address }
      else
        format.html { render :edit }
        format.json { render json: @address.errors, status: :unprocessable_entity }
      end
    end
  end

  # # DELETE /addresses/1
  # # DELETE /addresses/1.json
  # def destroy
  #   @address.destroy
  #   respond_to do |format|
  #     format.html { redirect_to customer_addresses_url(current_customer), notice: 'Address was successfully destroyed.' }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_address
      @address = Address.find(params[:id])
    end

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
