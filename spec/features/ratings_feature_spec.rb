require 'features/features_spec_helper'

feature 'rating management' do 
  background do
    @book = FactoryGirl.create :bestseller_book
    page.driver.delete destroy_admin_session_path
    page.driver.delete destroy_customer_session_path
  end

  context 'as authorized customer' do
    background do
      @customer = FactoryGirl.create :customer, 
                  email:                 'customer@mail.com', 
                  password:              '12345678',
                  password_confirmation: '12345678'
                  
      login_as @customer
    end

    # background {  }

    scenario 'add a rating to a book' do
      visit book_path(@book)
      click_link 'Add review for this book'
      fill_in 'Rating',   with: '10'
      fill_in 'Text review', with: 'some review'
      click_button 'Add'
      expect(page).to have_content "Rating was successfully created. " \
                                   "It will be available soon"
    end
  end
end