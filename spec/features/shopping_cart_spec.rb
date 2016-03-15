require 'features/features_spec_helper'
  
feature 'order_items management' do

  background do
    @book = FactoryGirl.create :book
  end

  scenario 'push order_item to cookies' do
    visit books_path
    click_button 'Add to Cart'
    expect(page).to have_content "\"#{@book.title}\" was added to cart"
  end

  scenario 'browse order_items in the cart' do
    @another_book = FactoryGirl.create :book
    visit books_path
    click_button "book_#{@book.id}_add"
    click_button "book_#{@another_book.id}_add"
    visit '/cart'
    expect(page).to have_content "#{@book.title}"
    expect(page).to have_content "#{@another_book.title}"
  end
  
end