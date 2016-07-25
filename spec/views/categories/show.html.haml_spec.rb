require 'rails_helper'
require 'shared/views/shared_books_categories_view_specs'

RSpec.describe "categories/show", type: :view do
  before do
    @category = assign(:category, 
      FactoryGirl.build_stubbed(:category, title: 'bestsellers'))
  end

  it_behaves_like 'books_categories specs', true
end
