require 'rails_helper'

RSpec.describe "ratings/new", type: :view do
  before(:each) do
    @book = FactoryGirl.create :book
    @rating = FactoryGirl.build :rating, book_id: @book.id
    render
  end

  it "renders _form partial" do
    expect(view).to render_template(partial: '_form')
  end

  it "displays link to @book" do
    expect(rendered).to have_selector(
      "a[href=\"#{book_path(@book)}\"]", text: 'Back')
  end
end
