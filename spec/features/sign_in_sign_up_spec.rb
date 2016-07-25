require 'features/features_spec_helper'
require 'shared/features/shared_sign_in_sign_up_feature_specs.rb'

feature "customer signing in" do
  include_context 'bestseller book creation'

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
    fill_in 'customer_email',    with: customer.email
    fill_in 'customer_password', with: customer.password
    click_button t("sign_in_page.sign_in")

    expect(page).to have_content t("devise.sessions.signed_in")
  end

  scenario "failed to sign in with incorrect email" do
    fill_in 'customer_email',    with: 'wrong@mail.com'
    fill_in 'customer_password', with: customer.password
    click_button t("sign_in_page.sign_in")   

    expect(page).to have_content(
      t("devise.failure.invalid", authentication_keys: "email"))
  end

  scenario "failed to sign in with incorrect password" do
    fill_in 'customer_email',    with: customer.email
    fill_in 'customer_password', with: 'wrong_password'
    click_button t("sign_in_page.sign_in") 

    expect(page).to have_content(
      t("devise.failure.invalid", authentication_keys: "email"))
  end

  context "sign in via Facebook" do
    it_behaves_like 'sign in or sign up via Facebook'    
  end
end

feature "admin signing in" do
  include_context 'bestseller book creation'
  
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
    fill_in 'admin_email',    with: admin.email
    fill_in 'admin_password', with: admin.password
    click_button t("sign_in_page.sign_in")

    expect(page).to have_content t("devise.sessions.signed_in")
  end

  scenario "failed to sign in with incorrect email" do
    fill_in 'admin_email',    with: 'wrong@mail.com'
    fill_in 'admin_password', with: admin.password
    click_button t("sign_in_page.sign_in")   

    expect(page).to have_content(
      t("devise.failure.invalid", authentication_keys: "email"))
  end

  scenario "failed to sign in with incorrect password" do
    fill_in 'admin_email',    with: admin.email
    fill_in 'admin_password', with: 'wrong_password'
    click_button t("sign_in_page.sign_in") 

    expect(page).to have_content(
      t("devise.failure.invalid", authentication_keys: "email"))
  end
end

feature 'customer signing up' do
  include_context 'bestseller book creation'

  background do
    page.driver.delete destroy_admin_session_path
    page.driver.delete destroy_customer_session_path
    visit new_customer_registration_path
  end

  scenario 'successfully sign up with valid credentials' do
    fill_in 'customer_email',                 with: 'john_doe@mail.com'
    fill_in 'customer_password',              with: 'password'
    fill_in 'customer_password_confirmation', with: 'password'
    click_button t("sign_in_page.sign_up") 

    expect(page).to have_content t("devise.registrations.signed_up")
  end

  scenario 'failed to sign up with invalid credentials' do
    fill_in 'customer_email',                 with: 'invalid@mail'
    fill_in 'customer_password',              with: 'wrong'
    fill_in 'customer_password_confirmation', with: 'wrong1'
    click_button t("sign_in_page.sign_up") 

    expect(page).to have_content(
      'is invalid is too short (minimum is 8 characters)')
  end

  context "sign up via Facebook" do
    it_behaves_like 'sign in or sign up via Facebook'    
  end
end