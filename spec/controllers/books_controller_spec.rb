require 'rails_helper'
require 'shared/controllers/shared_controllers_specs'

RSpec.describe BooksController, type: :controller do
  let(:book) { FactoryGirl.create :book_of_category }
  let(:customer) { FactoryGirl.create(:customer) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:customer]
    sign_in customer
  end

  describe "GET #index" do  
    subject { get :index }

    before do
      books = Kaminari.paginate_array(FactoryGirl.create_list :book, 3).page(1)
      controller.instance_variable_set(:@books, books)
    end

    it_behaves_like "load and authorize resource", :book
    it_behaves_like 'check abilities', :read, Book
    it_behaves_like 'assigning', :categories
  end

  describe "GET #show" do
    subject { get :show, {id: book.to_param} }
    
    it_behaves_like "load and authorize resource", :book
    it_behaves_like 'check abilities', :read, Book
  end
end