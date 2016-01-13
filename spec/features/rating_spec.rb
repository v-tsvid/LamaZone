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
                  
      sign_in_via_capybara @customer
    end

    # background {  }

    scenario 'add rating to book' do
      visit book_path(@book)
      click_link 'Add review'
      fill_in 'Rate',   with: '10'
      fill_in 'Review', with: 'some review'
      click_button 'Save'
      expect(page).to have_content 'Rating was successfully created.'
    end

    background do
      @rating = FactoryGirl.create :rating,
               rate: '10',
               review: 'review', 
               customer_id: @customer.id, 
               book_id: @book.id, 
               state: 'approved'
    end

    scenario 'update own rating' do     
      visit edit_rating_path(@rating)
      fill_in 'Rate',   with: '1'
      fill_in 'Review', with: 'new review'
      click_button 'Save'
      expect(page).to have_content "Rating was successfully updated."
    end

    scenario 'delete own rating' do
      rating = FactoryGirl.create :rating, 
               customer_id: @customer.id,
               book_id: @book_id, 
               state: 'approved'
      visit book_ratings_path(@book)
      first(:link, 'Destroy').click
      expect(page).to have_content "Rating was successfully destroyed."
    end
  end
end