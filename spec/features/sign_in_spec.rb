require 'features/features_spec_helper'

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

  # scenario "visit sign in page" do
  #   expect(page).to have_content 'Sign In'
  #   expect(page).to have_field 'Email'
  #   expect(page).to have_field 'Password'
  #   expect(page).to have_content 'Remember me'
  #   expect(page).to have_button 'Sign in'
  #   expect(page).to have_link 'Sign up'
  #   expect(page).to have_link 'Forgot your password?'
  # end

  scenario "successfully sign in with correct email and password" do
    fill_in 'Email',    with: customer.email
    fill_in 'Password', with: customer.password
    click_button 'Sign in'

    expect(page).to have_content 'Signed in successfully'
    # expect(page).to have_content 'Listing books'
    # expect(page).not_to have_link 'Admin Panel'
  end

  scenario "failed sign in with incorrect email" do
    fill_in 'Email',    with: 'wrong@mail.com'
    fill_in 'Password', with: customer.password
    click_button 'Sign in'    

    expect(page).to have_content 'Invalid email or password'
    # expect(page).not_to have_content 'Listing books'
  end

  scenario "failed sign in with incorrect password" do
    fill_in 'Email',    with: customer.email
    fill_in 'Password', with: 'wrong_password'
    click_button 'Sign in'    

    expect(page).to have_content 'Invalid email or password'
    # expect(page).not_to have_content 'Listing books'
  end

  context "sign in/sign up via Facebook" do
   
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
      first(:link, text: 'Sign in with Facebook').click

      expect(page).
        to have_content 'Successfully authenticated from Facebook account.'
      # expect(page).to have_content 'Listing books'
    end

    scenario "successfully sign up with Facebook profile of unexisitng user" do
      valid_facebook_sign_in
      Rails.application.env_config["omniauth.auth"] = 
        OmniAuth.config.mock_auth[:facebook]
      first(:link, text: 'Sign in with Facebook').click

      expect(page).
        to have_content 'Successfully authenticated from Facebook account.'
      # expect(page).to have_content 'Listing books'
    end

    scenario "successfully sign up when email was not fetched from Facebook" do
      valid_facebook_sign_in
      OmniAuth.config.mock_auth[:facebook].info.email = nil
      Rails.application.env_config["omniauth.auth"] = 
        OmniAuth.config.mock_auth[:facebook]
      first(:link, text: 'Sign in with Facebook').click

      expect(page).
        to have_content 'Successfully authenticated from Facebook account.'
      # expect(page).to have_content 'Listing books'
    end

    scenario "failed sign in with invalid crendentials" do
      invalid_facebook_sign_in
      Rails.application.env_config["omniauth.auth"] = 
        OmniAuth.config.mock_auth[:facebook]
      first(:link, text: 'Sign in with Facebook').click

      expect(page).
        to have_content 'Invalid crendentials'
      # expect(page).to have_selector('h2', text: 'Sign in')
    end
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

  # scenario "visit sign in page" do
  #   expect(page).to have_content 'Sign In'
  #   expect(page).to have_field 'Email'
  #   expect(page).to have_field 'Password'
  #   expect(page).to have_content 'Remember me'
  #   expect(page).to have_button 'Sign in'
  #   expect(page).not_to have_link 'Sign up'
  #   expect(page).to have_link 'Forgot your password?'
  # end

  scenario "successfully sign in with correct email and password" do
    fill_in 'Email',    with: admin.email
    fill_in 'Password', with: admin.password
    click_button 'Sign in'

    expect(page).to have_content 'Signed in successfully'
    # expect(page).to have_content 'Listing books'
    # expect(page).to have_link 'Admin Panel'
  end

  scenario "failed sign in with incorrect email" do
    fill_in 'Email',    with: 'wrong@mail.com'
    fill_in 'Password', with: admin.password
    click_button 'Sign in'    

    expect(page).to have_content 'Invalid email or password'
    # expect(page).not_to have_content 'Listing books'
  end

  scenario "failed sign in with incorrect password" do
    fill_in 'Email',    with: admin.email
    fill_in 'Password', with: 'wrong_password'
    click_button 'Sign in'    

    expect(page).to have_content 'Invalid email or password'
    # expect(page).not_to have_content 'Listing books'
  end
end