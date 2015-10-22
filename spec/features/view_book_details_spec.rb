require 'features/features_spec_helper'

feature "view book details" do
  background do
    @book = FactoryGirl.create :book
  end

  scenario "click \"Details\" of certain book and see details" do
    visit books_path
    click_link 'Details'
    expect(page).to have_content @book.title
    expect(page).to have_content @book.description
    expect(page).to have_content @book.price
    expect(page).to have_content @book.books_in_stock
    expect(page).to have_content @book.author.lastname
  end
end