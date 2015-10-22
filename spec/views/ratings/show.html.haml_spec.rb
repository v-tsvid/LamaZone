require 'rails_helper'

RSpec.describe "ratings/show", type: :view do
  before(:each) do
    @book = FactoryGirl.create :book
    @rating = FactoryGirl.create :rating, book_id: @book.id
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/#{@rating.rate}/)
    expect(rendered).to match(/#{@rating.review}/)
  end
end
