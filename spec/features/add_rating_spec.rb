require 'features/features_spec_helper'

feature 'rating addition' do 
  background do
    @books = FactoryGirl.create_list :book, 2
    page.driver.delete destroy_admin_session_path
    page.driver.delete destroy_customer_session_path
  end

  scenario 'failed to add rating as unauthorized customer' do
    visit book_path(@books[0].id)
    click_link 'Add review'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  context 'as authorized customer' do
    given(:customer) { FactoryGirl.create :customer, 
                     email:                 'customer@mail.com', 
                     password:              '12345678',
                     password_confirmation: '12345678'}

    background do
      sign_in customer
      visit book_path(@books[0].id)
      click_link 'Add review'
    end

    scenario 'successfully add rating with valid data' do
      fill_in 'Rate',   with: '10'
      fill_in 'Review', with: 'some rating'
      click_button 'Create Rating'
      expect(page).to have_content 'Rating was successfully created.'
    end

    scenario 'failed to add rating with invalid data' do
      fill_in 'Rate',   with: '-1'
      fill_in 'Review', with: 'some rating'
      click_button 'Create Rating'
      expect(page).to have_content 'New Rating'
    end
  end
end