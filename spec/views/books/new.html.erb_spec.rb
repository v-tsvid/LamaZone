require 'rails_helper'

RSpec.describe "books/new", type: :view do
  before(:each) do
    assign(:book, Book.new(
      :title => "MyString",
      :description => "MyText",
      :price => "9.99",
      :books_in_stock => 1
    ))
  end

  it "renders new book form" do
    render

    assert_select "form[action=?][method=?]", books_path, "post" do

      assert_select "input#book_title[name=?]", "book[title]"

      assert_select "textarea#book_description[name=?]", "book[description]"

      assert_select "input#book_price[name=?]", "book[price]"

      assert_select "input#book_books_in_stock[name=?]", "book[books_in_stock]"
    end
  end
end
