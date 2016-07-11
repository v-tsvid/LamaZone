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

    scenario 'add a rating to a book' do
      visit book_path(@book)
      click_link t(:add_review)
      fill_in t(:rating),   with: '10'
      fill_in t(:text_review), with: 'some review'
      click_button t(:add)
      expect(page).to have_content t("controllers.rating_created")
    end
  end
end