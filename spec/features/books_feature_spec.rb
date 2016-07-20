require 'features/features_spec_helper'

feature 'books catalogue browsing' do
  background do
    @category = FactoryGirl.create :category_with_books, num: 3
    @another_category = FactoryGirl.create :category
    @another_book = FactoryGirl.create :book
  end

  context "home page" do
    background do
      @best_category = FactoryGirl.create :category, title: 'bestsellers'
      @best_books = FactoryGirl.create_list :book, 2
      @best_category.books << @best_books
      visit root_path
    end

    scenario "see carousel with bestsellers" do
      expect(page).to have_css("div#bestBooksCarousel.carousel.slide")
      @best_books.each do |book|
        expect(page).to have_content book.title
      end
    end
  end

  scenario 'select some category' do
    visit "/categories/#{@category.id}"
    
    expect(page).to have_content t("categories.#{@category.title}")
    @category.books.each do |book|
      expect(page).to have_content book.title
    end
  end

  background { visit books_path }
  
  scenario 'view the books catalogue' do

    expect(page).to have_content @another_book.title
    @category.books.each do |book|
      expect(page).to have_content book.title
    end
  end 

  scenario 'view the categories list in the books catalogue' do
    [@category, @another_category].each do |cat|
      expect(page).to have_content t("categories.#{cat.title}")
    end
  end

  scenario "see the book's details" do
    visit book_path(@another_book)

    expect(page).to have_content @another_book.title
    expect(page).to have_content @another_book.description
    expect(page).to have_content @another_book.price
    expect(page).to have_content(
      PersonDecorator.decorate(@another_book.author).full_name)
  end
end