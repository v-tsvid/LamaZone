require 'rails_helper'
require 'views/books_categories_spec'

RSpec.describe "books/index", type: :view do

  it_behaves_like 'books_categories specs', false
end
