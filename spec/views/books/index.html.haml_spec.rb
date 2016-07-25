require 'rails_helper'
require 'shared/views/shared_books_categories_view_specs'

RSpec.describe "books/index", type: :view do

  it_behaves_like 'books_categories specs', false
end
