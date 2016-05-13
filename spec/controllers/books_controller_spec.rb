require 'rails_helper'
require 'controllers/shared/shared_controller_specs'

RSpec.describe BooksController, type: :controller do
  let(:best_book) { FactoryGirl.create :bestseller_book }
  let(:book) { FactoryGirl.create :book_of_category }
  let(:customer) { FactoryGirl.create(:customer) }
  let(:book_params) { 
    FactoryGirl.attributes_for(:book, id: book.id).stringify_keys }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:customer]
    sign_in customer
  end

  describe "GET #index" do  
    subject { get :index }

    it_behaves_like "load and authorize resource"

    it "assigns all books as @books" do
      subject
      expect(assigns(:books)).to eq [book, best_book]
    end

    it "assigns all categories as @categories" do
      categories = FactoryGirl.create_list :category, 3
      subject
      expect(assigns(:categories)).to eq categories
    end
  end

  describe "GET #show" do
    subject { get :show, {id: book.to_param} }
    
    it_behaves_like "load and authorize resource"
    
    it "assigns the requested book as @book" do
      subject
      expect(assigns(:book)).to eq(book)
    end
  end
end