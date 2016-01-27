require 'features/features_spec_helper'

feature "address management by authorized customer" do
  background do
    page.driver.delete destroy_admin_session_path
    page.driver.delete destroy_customer_session_path
    
    @customer = FactoryGirl.create :customer, 
                  email:                 'customer@mail.com', 
                  password:              '12345678',
                  password_confirmation: '12345678'
                  
    sign_in_via_capybara @customer
  end

  scenario 'add address' do
    visit new_customer_address_path(@customer)
    fill_in 'Contact name',    with: 'some_name'
    fill_in 'Phone',    with: '380930000000'
    fill_in 'Address1', with: 'some_address'
    fill_in 'Address2', with: 'some_address'
    fill_in 'City',     with: 'some_city'
    fill_in 'Zipcode',  with: '49000'
    find('#address_country_id').find(:xpath, 'option[1]').select_option
    click_button('Create Address')
    expect(page).to have_content 'Address was successfully created.'
  end

  scenario 'edit address' do
  end

  scenario 'remove address' do
  end


end