require 'rails_helper'

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
    context "if params contains category" do
      let(:category) { best_book.categories[0].to_param }

      it "receives books_of_category with params[:category] on Book" do
        expect(Book).to receive(:books_of_category).with category
        get :index, { category: category }
      end

      before { get :index, { category: category } }

      it "assigns books of certain category as @books" do
        expect(assigns(:books)).to eq [best_book]
      end

      it "assigns params[:category] as @category_id" do
        expect(assigns(:category_id)).to eq category
      end
    end

    context "if params doesn't contain category" do
      it "assigns all books as @books" do
        get :index
        expect(assigns(:books)).to eq [book, best_book]
      end

      it "assigns -1 as @category_id" do
        get :index
        expect(assigns(:category_id)).to eq '-1'
      end
    end
  end

  describe "GET #show" do
    it "assigns the requested book as @book" do
      get :show, {:id => book.to_param}
      expect(assigns(:book)).to eq(book)
    end

    it "receives set_book" do
      expect(controller).to receive(:set_book)
      get :show, {:id => book.to_param}
    end
  end

  describe ".set_book" do
    it "receives find on Book and returns book with requested id" do
      expect(Book).to receive(:find).with(book_params[:id])
      controller.send(:set_book)
    end
  end
end
