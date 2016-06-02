require 'rails_helper'
require 'controllers/shared/shared_controller_specs'

RSpec.describe RatingsController, type: :controller do

  let(:customer) { FactoryGirl.create(:customer) }
  let(:book) { FactoryGirl.create(:book) }
  let(:rating_params) { 
    FactoryGirl.attributes_for(:rating, book_id: book.id).stringify_keys }
  let(:invalid_rating_params) { 
    FactoryGirl.attributes_for(
      :rating, book_id: book.id, rate: 'invalid').stringify_keys }
  let(:rating) { FactoryGirl.create(:rating, book_id: book.id, 
    customer_id: customer.id, state: 'approved') }
  let(:wrong_book) { FactoryGirl.create(:book) }
  let(:wrong_rating) { FactoryGirl.create(:rating, 
    book_id: wrong_book.id, state: 'approved') }
  

  before do
    @request.env["devise.mapping"] = Devise.mappings[:customer]
    sign_in customer
  end

  describe "GET #new" do

    subject { get :new, { book_id: book.id } }
    
    context "messages receiving" do

      it_behaves_like "customer authentication"

      it "receives find on Book and return book with requested id" do
        expect(Book).to receive(:find_by_id).with(book.id.to_s).and_return(book)
        subject
      end

      it "receives new on Rating with finded book" do
        expect(Rating).to receive(:new).with(book: book, customer: customer)
        subject
      end
    end

    it "assigns requested book as @book" do
      subject
      expect(assigns(:book)).to eq(book)
    end

    it "assigns a new rating as @rating" do  
      subject
      expect(assigns(:rating)).to be_a_new(Rating)
    end
  end

  describe "POST #create" do

    subject { post :create, { rating: rating_params, book_id: book.id } }

    context "messages receiving" do
      it_behaves_like "customer authentication"
    end

    context "with valid params" do

      it "receives find on Book with requested book_id" do
        expect(Book).to receive(:find_by_id).with(rating_params['book_id'].to_s).
          and_return(book)
        subject
      end

      it "creates a new rating" do
        expect { subject }.to change(Rating, :count).by(1)
      end

      it "assigns book for requested rating as @book" do
        subject
        expect(assigns(:book)).to eq(book)
      end

      it "assigns a newly created rating as @rating" do
        subject
        expect(assigns(:rating)).to be_a(Rating)
        expect(assigns(:rating)).to be_persisted
      end

      it "sets customer for rating with current_customer value" do
        subject
        expect(assigns(:rating).customer_id).to eq controller.current_customer.id
      end

      it "redirects to the created rating" do
        subject
        expect(response).to redirect_to(book_path(book))
      end
    end

    context "with invalid params" do

      subject { post :create, { rating: invalid_rating_params, book_id: book.id } }

      it "assigns a newly created but unsaved rating as @rating" do
        subject
        expect(assigns(:rating)).to be_a_new(Rating)
      end

      it "re-renders the 'new' template" do
        subject
        expect(response).to render_template("new")
      end
    end
  end
end
