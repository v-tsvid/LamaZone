require 'features/features_spec_helper'

feature 'category selection' do
  background do
    @best_book = FactoryGirl.create :bestseller_book
    @book = FactoryGirl.create :book_of_category
  end

  scenario 'select bestsellers category' do
    visit "/books?category=#{Category.find_by_title('bestsellers').id}"

    expect(page).to have_content @best_book.title
    expect(page).not_to have_content @book.title
  end  

  scenario 'select another category' do
    visit "/books?category=#{Category.find_by_title('bestsellers').id + 1}"

    expect(page).not_to have_content @best_book.title
    expect(page).to have_content @book.title
  end 

  scenario 'select all the books' do
    visit books_path

    expect(page).to have_content @best_book.title
    expect(page).to have_content @book.title
  end 

end