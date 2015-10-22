require 'rails_helper'

RSpec.describe "ratings/edit", type: :view do
  before(:each) do
    @book = FactoryGirl.create :book
    @rating = FactoryGirl.create :rating, book_id: @book.id
  end
  
  # it "renders the edit rating form" do
  #   render

  #   assert_select "form[action=?][method=?]", rating_path(@rating), "post" do

  #     assert_select "input#rating_rate[name=?]", "rating[rate]"

  #     assert_select "textarea#rating_review[name=?]", "rating[review]"
  #   end
  # end
end
