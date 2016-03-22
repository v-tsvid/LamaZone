require 'rails_helper'

RSpec.describe "categories/show", type: :view do
  before(:each) do
    @category = assign(:category, stub_model(Category, title: '123'))

    @books = assign(:books, 
      [stub_model(Book, 
        title: 'title1', 
        price: 1.0,
        category_id: @category.id),
       stub_model(Book, 
        title: 'title2', 
        price: 2.0,
        category_id: @category.id)])

    @books.each do |book|
      [:firstname, :lastname].each do |item|
        allow(book).to receive_message_chain(:author, item)
      end
    end
  end

  it "renders the title of the category" do
    render
    expect(rendered).to match(@category.title.capitalize)
  end

  it "renders the titles of the category's books" do
    render
    @books.each do |book|
      expect(rendered).to match(book.title)
    end
  end

  it "renders the prices of the category's books" do
    render
    @books.each do |book|
      expect(rendered).to match("#{book.price}")
    end
  end

  it "renders the name of the author of the category's books" do
    render
    @books.each do |book|
      expect(rendered).to match(book.author.full_name)
    end
  end

  it "renders the link to the detailed information for the book" do
    render
    @books.each do |book|
      expect(rendered).to have_link('Details', "books/#{book.id}")
    end
  end

  it "renders the link to the whole books list" do
    render
    expect(rendered).to have_link('Back', "/")
  end
end
