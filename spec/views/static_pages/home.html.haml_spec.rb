require 'rails_helper'

RSpec.describe "static_pages/home.html.haml", type: :view do
  
  before do
    @books = assign(:books, [
      stub_model(Book,
        images: File.open(Rails.root + "app/assets/images/books_images/51AdUxb4frL.jpg")), 
      stub_model(Book,
        images: File.open(Rails.root + "app/assets/images/books_images/51KBQZ+S9+L.jpg"))])

    @books.each do |book|
      [:firstname, :lastname].each do |item|
        allow(book).to receive_message_chain(:author, item)
      end
    end

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
        expect(rendered).to match(book.send(item).to_s) 
      end
    end
  end

  it "displays books in stock quantity" do
    @books.each do |book|
      expect(rendered).to match(book.send(:books_in_stock).to_s) 
    end
  end

  [:firstname, :lastname].each do |item|
    it "displays #{item} of books' authors" do
      @books.each do |book|
        expect(rendered).to match(book.author.send(item).to_s) 
      end
    end
  end
end