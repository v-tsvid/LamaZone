require 'rails_helper'

RSpec.describe "ratings/new", type: :view do
  before(:each) do
    @book = FactoryGirl.create :book
    @rating = FactoryGirl.build :rating, book_id: @book.id
  end

  # it "renders new rating form" do
  #   render

  #   assert_select "form[action=?][method=?]", ratings_path, "post" do

  #     assert_select "input#rating_rate[name=?]", "rating[rate]"

  #     assert_select "textarea#rating_review[name=?]", "rating[review]"
  #   end
  # end
end
