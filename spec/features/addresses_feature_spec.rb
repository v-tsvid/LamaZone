require 'features/features_spec_helper'

feature "address management by authorized customer" do
  background do
    page.driver.delete destroy_admin_session_path
    page.driver.delete destroy_customer_session_path
    
    @bil_address = FactoryGirl.create :address, firstname: 'name1', lastname: 'name2'
    @ship_address = FactoryGirl.create :address, firstname: 'name3', lastname: 'name4'
    
    @customer = FactoryGirl.create :customer, 
                  email:                 'customer@mail.com', 
                  password:              '12345678',
                  password_confirmation: '12345678',
                  billing_address:       @bil_address,
                  shipping_address:      @ship_address
                  
    login_as @customer
    visit edit_customer_registration_path
  end

  [:billing_address, :shipping_address].each do |item|
    scenario "see own #{item.to_s.humanize.downcase} on the settings page" do
      expect(page).to have_selector("input[value='#{@customer.send(item).firstname}']")
      expect(page).to have_selector("input[value='#{@customer.send(item).lastname}']")
    end

    scenario "see own #{item.to_s.humanize.downcase} on the settings page" do
      expect(page).to have_selector("input[value='#{@customer.send(item).firstname}']")
      expect(page).to have_selector("input[value='#{@customer.send(item).lastname}']")
    end
  end

  # scenario "see own addresses on the settings page" do
  #   expect(page).to have_content @bil_address.firstname
  # end

  scenario "edit own address on the settings page"

  
end