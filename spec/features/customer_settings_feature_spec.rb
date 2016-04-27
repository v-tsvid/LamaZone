require 'features/features_spec_helper'

feature "settings of authorized customer" do
  background do
    page.driver.delete destroy_admin_session_path
    page.driver.delete destroy_customer_session_path
    
    @current_password = '12345678'
    @bil_address = FactoryGirl.create :address, firstname: 'name1', lastname: 'name2'
    @ship_address = FactoryGirl.create :address, firstname: 'name3', lastname: 'name4'
    
    @customer = FactoryGirl.create :customer, 
                  email:                 'customer@mail.com', 
                  password:              @current_password,
                  password_confirmation: @current_password,
                  billing_address:       @bil_address,
                  shipping_address:      @ship_address
    
    @book = FactoryGirl.build_stubbed :book
    allow(Book).to receive(:books_of_category).with('bestsellers').
      and_return [@book]
                  
    login_as @customer
  end

  scenario "visit settings page" do
    visit edit_customer_registration_path
    expect(page).to have_selector('h3', text: 'Settings')
  end

  background { visit edit_customer_registration_path }

  [:billing_address, :shipping_address].each do |item|
    scenario "see own #{hum_and_down_sym(item)} on the settings page" do
      expect(page).to have_selector("input[value='#{@customer.send(item).firstname}']")
      expect(page).to have_selector("input[value='#{@customer.send(item).lastname}']")
    end

    scenario "edit own #{hum_and_down_sym(item)} on the settings page" do
      new_name = "new" + @customer.send(item).firstname
      
      within(".#{item.to_s}_form") do
        fill_in 'address_firstname', with: new_name
        click_button 'SAVE'
      end
      expect(page).to have_text 'Address was successfully updated.'
    end 
  end

  [:email, :password].each do |item|
    scenario "edit own #{hum_and_down_sym(item)}" do
      within(".#{item.to_s}_form") do
        new_param = item == :email ? 'new@mail.com' : 'newpassword'
        if item == :email
          fill_in 'customer_email', with: new_param
        else
          fill_in 'customer_current_password', with: @current_password
          fill_in 'customer_password', with: new_param
        end
        click_button 'SAVE'
      end
      expect(page).to have_text 'Your account has been updated successfully.'
    end
  end

  scenario "remove own account" do
    find(:css, "#confirm").set(true)   
    click_button 'PLEASE REMOVE MY ACCOUNT'
    expect(page).to have_text(
      "Bye! Your account has been successfully cancelled. " \
      "We hope to see you again soon.")
  end
end