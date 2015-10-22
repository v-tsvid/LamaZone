require 'features/features_spec_helper'

shared_examples 'sign in or sign up via Facebook' do
  background do
    correct_customer = Customer.find_by(email: 'vad_1989@mail.ru')
    correct_customer.destroy if correct_customer
  end

  given(:fb_customer) {
    FactoryGirl.build(:customer, firstname: "Vadim", lastname: "Tsvid",
                      email: 'vad_1989@mail.ru', password: '12345678',
                      password_confirmation: '12345678',
                      provider: "facebook", uid: "580001345483302") }
   
  scenario "successfully sign in with Facebook profile of exisitng user" do
    fb_customer.save
    valid_facebook_sign_in
    Rails.application.env_config["omniauth.auth"] = 
      OmniAuth.config.mock_auth[:facebook]
    first(:link, text: link_to_click).click

    expect(page).
      to have_content 'Successfully authenticated from Facebook account.'
  end

  scenario "successfully sign up with Facebook profile of unexisitng user" do
    valid_facebook_sign_in
    Rails.application.env_config["omniauth.auth"] = 
      OmniAuth.config.mock_auth[:facebook]
    first(:link, text: link_to_click).click

    expect(page).
      to have_content 'Successfully authenticated from Facebook account.'
  end

  scenario "successfully sign up when email was not fetched from Facebook" do
    valid_facebook_sign_in
    OmniAuth.config.mock_auth[:facebook].info.email = nil
    Rails.application.env_config["omniauth.auth"] = 
      OmniAuth.config.mock_auth[:facebook]
    first(:link, text: link_to_click).click

    expect(page).
      to have_content 'Successfully authenticated from Facebook account.'
  end

  scenario "failed to sign in with invalid credentials" do
    invalid_facebook_sign_in
    Rails.application.env_config["omniauth.auth"] = 
      OmniAuth.config.mock_auth[:facebook]
    first(:link, text: link_to_click).click

    expect(page).
      to have_content 'Invalid credentials'
  end
end

feature "customer signing in" do
  given(:customer) { FactoryGirl.create :customer, 
                     email:                 'customer@mail.com', 
                     password:              '12345678',
                     password_confirmation: '12345678'}

  background do
    Rails.application.env_config["devise.mapping"] = Devise.mappings[:customer]
    logout customer
    visit new_customer_session_path
  end

  scenario "successfully sign in with correct email and password" do
    fill_in 'Email',    with: customer.email
    fill_in 'Password', with: customer.password
    click_button 'Sign in'

    expect(page).to have_content 'Signed in successfully'
  end

  scenario "failed to sign in with incorrect email" do
    fill_in 'Email',    with: 'wrong@mail.com'
    fill_in 'Password', with: customer.password
    click_button 'Sign in'    

    expect(page).to have_content 'Invalid email or password'
  end

  scenario "failed to sign in with incorrect password" do
    fill_in 'Email',    with: customer.email
    fill_in 'Password', with: 'wrong_password'
    click_button 'Sign in'    

    expect(page).to have_content 'Invalid email or password'
  end

  context "sign in via Facebook" do
    given(:link_to_click) { 'Sign in with Facebook' }

    it_behaves_like 'sign in or sign up via Facebook'    
  end
end

feature "admin signing in" do
  given(:admin) { FactoryGirl.create :admin, 
                  email:                 'admin@mail.com', 
                  password:              '12345678',
                  password_confirmation: '12345678' }
  
  background do
    page.driver.delete destroy_admin_session_path
    page.driver.delete destroy_customer_session_path
    visit new_admin_session_path
  end

  scenario "successfully sign in with correct email and password" do
    fill_in 'Email',    with: admin.email
    fill_in 'Password', with: admin.password
    click_button 'Sign in'

    expect(page).to have_content 'Signed in successfully'
  end

  scenario "failed to sign in with incorrect email" do
    fill_in 'Email',    with: 'wrong@mail.com'
    fill_in 'Password', with: admin.password
    click_button 'Sign in'    

    expect(page).to have_content 'Invalid email or password'
  end

  scenario "failed to sign in with incorrect password" do
    fill_in 'Email',    with: admin.email
    fill_in 'Password', with: 'wrong_password'
    click_button 'Sign in'    

    expect(page).to have_content 'Invalid email or password'
  end
end

feature 'customer signing up' do

  background do
    page.driver.delete destroy_admin_session_path
    page.driver.delete destroy_customer_session_path
    visit new_customer_registration_path
  end

  scenario 'successfully sign up with valid credentials' do
    fill_in 'Firstname',             with: 'John'
    fill_in 'Lastname',              with: 'Doe'
    fill_in 'Email',                 with: 'john_doe@mail.com'
    fill_in 'Password',              with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'failed to sign up with invalid credentials' do
    fill_in 'Firstname',             with: ''
    fill_in 'Lastname',              with: ''
    fill_in 'Email',                 with: 'invalid@mail'
    fill_in 'Password',              with: 'wrong'
    fill_in 'Password confirmation', with: 'wrong1'
    click_button 'Sign up'

    expect(page).to have_content 'prohibited this customer from being saved'
  end

  context "sign up via Facebook" do
    given(:link_to_click) { 'Sign up with Facebook' }

    it_behaves_like 'sign in or sign up via Facebook'    
  end
end