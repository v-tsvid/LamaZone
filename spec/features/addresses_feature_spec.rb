# require 'features/features_spec_helper'

# feature "address management by authorized customer" do
#   background do
#     page.driver.delete destroy_admin_session_path
#     page.driver.delete destroy_customer_session_path
    
#     @bil_address = FactoryGirl.create :address
#     @ship_address = FactoryGirl.create :address
    
#     @customer = FactoryGirl.create :customer, 
#                   email:                 'customer@mail.com', 
#                   password:              '12345678',
#                   password_confirmation: '12345678',
#                   billing_address:       @bil_address,
#                   shipping_address:      @ship_address
                  
#     sign_in_via_capybara @customer
#   end

  
# end