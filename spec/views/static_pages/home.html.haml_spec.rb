require 'rails_helper'

RSpec.describe "static_pages/home.html.haml", type: :view do
  
  before do
    @books = assign(:books, [
      FactoryGirl.build_stubbed(:book,
        images: File.open(Rails.root + "app/assets/images/books-images/51AdUxb4frL.jpg")), 
      FactoryGirl.build_stubbed(:book,
        images: File.open(Rails.root + "app/assets/images/books-images/51KBQZ+S9+L.jpg"))])


    allow(view).to receive(:cool_price)
    allow_any_instance_of(Author).to receive(:full_name)
    render
  end
  
  it "renders _book partial" do
    expect(view).to render_template(partial: '_book')
  end

  it "displays bootstrap carousel for books" do
    expect(rendered).to have_selector "[id='bestBooksCarousel']"
  end
  
  [:title, :price].each do |item|
    it "displays books' #{item.to_s.pluralize}" do
      @books.each do |book|
        allow(view).to receive(:cool_price).and_return(book.price) if item == :price
        render
        expect(rendered).to match(book.send(item).to_s) 
      end
    end
  end

  it "displays books in stock quantity" do
    @books.each do |book|
      expect(rendered).to match(book.send(:books_in_stock).to_s) 
    end
  end

  it "displays full name of books' authors" do
    @books.each do |book|
      allow_any_instance_of(Author).to receive(:full_name).and_return(book.author.full_name)
      render
      expect(rendered).to match(book.author.full_name.to_s) 
    end
  end
end