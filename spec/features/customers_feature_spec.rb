require 'features/features_spec_helper'

feature "customer's account data management" do
    
  background do
    page.driver.delete destroy_admin_session_path
    page.driver.delete destroy_customer_session_path

    @bil_address = FactoryGirl.create :address
    @ship_address = FactoryGirl.create :address
    
    @customer = FactoryGirl.create :customer, 
                  email:                 'customer@mail.com', 
                  password:              '12345678',
                  password_confirmation: '12345678',
                  billing_address:       @bil_address,
                  shipping_address:      @ship_address
                  
    sign_in_via_capybara @customer
  end
  
  scenario "view customer's addresses on the profile page" do
    visit edit_customer_registration_path
    
    expect(page).to have_content 'My shipping address'
    expect(page).to have_content 'My billing address'
  end
  
  scenario "edit customer's profile" do
    visit edit_customer_registration_path
    
    fill_in 'customer_billing_address_attributes_firstname', with: 'new_firstname'
    fill_in 'customer_shipping_address_attributes_lastname', with: 'new_lastname'
    fill_in 'customer_email',                                with: 'new@mail.com'
    fill_in 'customer_password',                             with: '123456789'
    fill_in 'customer_password_confirmation',                with: '123456789'
    fill_in 'customer_current_password',                     with: '12345678'
    
    click_button 'Update'
    expect(page).to have_content 'Your account has been updated successfully.'
  end
end