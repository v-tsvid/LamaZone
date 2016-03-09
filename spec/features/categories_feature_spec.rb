require 'features/features_spec_helper'

feature 'category selection' do
  background do
    @category = FactoryGirl.create :category_with_books
    @another_category = FactoryGirl.create :category
    @another_book = FactoryGirl.create :book
  end

  scenario 'select some category' do
    visit "/categories/#{@category.id}"
    
    expect(page).to have_content "#{@category.title.capitalize}"
    @category.books.each do |book|
      expect(page).to have_content book.title
    end
  end

  background { visit books_path }
  
  scenario 'view the catalogue of the books with the categories list' do

    expect(page).to have_content @another_book.title
    @category.books.each do |book|
      expect(page).to have_content book.title
    end
  end 

  scenario 'view the categories list in the books catalogue' do
    [@category, @another_category].each do |cat|
      expect(page).to have_content cat.title
    end
  end

end