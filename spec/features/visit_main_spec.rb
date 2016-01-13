require 'features/features_spec_helper'

feature "visiting main" do
  given(:admin) { FactoryGirl.create :admin, 
                  email:                 'admin@mail.com', 
                  password:              '12345678',
                  password_confirmation: '12345678' }
  given(:customer) { FactoryGirl.create :customer, 
                     email:                 'customer@mail.com', 
                     password:              '12345678',
                     password_confirmation: '12345678'}

  background do
    logout admin
    logout customer
  end

  # scenario "as user not signed in" do
  #   visit root_path

  #   expect(page).to have_content 'Sign Up'
  #   expect(page).to have_content 'Sign In'
  #   expect(page).to have_content 'Listing books'

  #   expect(page).not_to have_content 'My Profile'
  #   expect(page).not_to have_content 'Sign Out'
  # end

  # scenario "as customer signed in" do
  #   sign_in_via_capybara customer

  #   expect(page).not_to have_content 'Sign Up'
  #   expect(page).not_to have_content 'Sign In'

  #   expect(page).to have_content 'Listing books'
  #   expect(page).to have_content 'My Profile'
  #   expect(page).to have_content 'Sign Out'
  # end

  # scenario "as admin signed in" do
  #   sign_in_via_capybara admin

  #   expect(page).not_to have_content 'Sign Up'
  #   expect(page).not_to have_content 'Sign In'

  #   expect(page).to have_content 'Listing books'
  #   expect(page).to have_content 'My Profile'
  #   expect(page).to have_content 'Sign Out'
  #   expect(page).to have_link 'Admin Panel'
  # end
end