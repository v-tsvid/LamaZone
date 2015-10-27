require 'rails_helper'

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

  shared_examples "customer authentication" do
    it "calls customer_authenticate! method" do
      expect(controller).to receive(:authenticate_customer!)
    end
  end

  shared_examples "rating setting" do
    it "calls set_rating method" do
      expect(controller).to receive(:set_rating)
    end
  end

  describe "GET #index" do

    it "assigns all approved ratings of requested book as @ratings" do
      rating
      wrong_rating
      get :index, { book_id: book.id }
      expect(assigns(:ratings)).to match_array([rating])
    end

    it "assigns as @ratings all approved ratings of current customer "\
       "when book wasn't requested" do
      rating
      wrong_rating
      get :index, { customer_id: customer.id }
      expect(assigns(:ratings)).to match_array([rating])
    end
    
    after { get :index, { book_id: book.id } }

    it "receives where on Rating "\
       "and returns all approved ratings of requested book" do
      expect(Rating).
        to receive(:where).with(state: 'approved', book_id: book.to_param).
          and_return [rating]
    end
  end

  describe "GET #show" do

    context "messages receiving" do

      after { get :show, { id: rating.to_param } }

      it_behaves_like "rating setting"
    end

    it "assigns the requested rating as @rating" do
      get :show, { id: rating.to_param }
      expect(assigns(:rating)).to eq(rating)
    end
  end

  describe "GET #new" do
    
    context "messages receiving" do

      after { get :new, { book_id: book.id } }

      it_behaves_like "customer authentication"

      it "receives find on Book and return book with requested id" do
        expect(Book).to receive(:find).with(book.id.to_s).and_return(book)
      end

      it "receives new on Rating with finded book" do
        expect(Rating).to receive(:new).with(book: book)
      end
    end

    before { get :new, { book_id: book.id } }

    it "assigns requested book as @book" do
      expect(assigns(:book)).to eq(book)
    end

    it "assigns a new rating as @rating" do  
      expect(assigns(:rating)).to be_a_new(Rating)
    end
  end

  describe "GET #edit" do

    context "messages receiving" do

      after { get :edit, { id: rating.id.to_param } }
      
      it_behaves_like "customer authentication"
      
      it "receives find on Rating with requested id" do
        expect(Rating).to receive(:find).with(rating.id.to_param).and_return(rating)
      end

      it "receives find on Book with requested id" do
        expect(Book).to receive(:find).with(rating.book_id).and_return(rating)
      end
    end 

    before { get :edit, { id: rating.to_param } }

    it "assigns the requested rating as @rating" do
      expect(assigns(:rating)).to eq(rating)
    end

    it "assigns the requested book as book in @rating" do
      expect(assigns(:book)).to eq(book)
    end
  end

  describe "POST #create" do

    context "messages receiving" do

      after { post :create, { rating: rating_params, book_id: book.id } }
    
      it_behaves_like "customer authentication"
    end

    context "with valid params" do

      it "receives find on Book with requested book_id" do
        expect(Book).to receive(:find).with(rating_params['book_id'].to_s).
          and_return(book)
        post :create, { rating: rating_params, book_id: book.id }
      end

      it "creates a new rating" do
        expect {
          post :create, { rating: rating_params, book_id: book.id }
        }.to change(Rating, :count).by(1)
      end

      before { post :create, { rating: rating_params, book_id: book.id } }

      it "assigns book for requested rating as @book" do
        expect(assigns(:book)).to eq(book)
      end

      it "assigns a newly created rating as @rating" do
        expect(assigns(:rating)).to be_a(Rating)
        expect(assigns(:rating)).to be_persisted
      end

      it "sets customer for rating with current_customer value" do
        expect(assigns(:rating).customer_id).to eq controller.current_customer.id
      end

      it "redirects to the created rating" do
        expect(response).to redirect_to(Rating.last)
      end
    end

    context "with invalid params" do

      before { post :create, { rating: invalid_rating_params, book_id: book.id } }

      it "assigns a newly created but unsaved rating as @rating" do
        expect(assigns(:rating)).to be_a_new(Rating)
      end

      it "re-renders the 'new' template" do
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do

    let(:new_rating_params) { 
      FactoryGirl.attributes_for(:rating, book_id: book.id).stringify_keys }

    context "messages receiving" do
    
      after { put :update, { id: rating.to_param, rating: new_rating_params } }

      it_behaves_like "customer authentication"
    end 

    context "with valid params" do
      
      before { put :update, { id: rating.to_param, rating: new_rating_params } }

      it "updates the requested rating" do
        rating.reload
        expect(assigns(:rating).review).to eq new_rating_params['review']
      end

      it "sets state of rating with 'pending' value" do
        expect(assigns(:rating).state).to eq 'pending'
      end

      it "assigns the requested rating as @rating" do
        expect(assigns(:rating)).to eq(rating)
      end

      it "redirects to the rating" do
        expect(response).to redirect_to(rating)
      end
    end

    context "with invalid params" do

      before { 
        put :update, { id: rating.to_param, rating: invalid_rating_params } 
      }

      it "assigns the rating as @rating" do
        expect(assigns(:rating)).to eq(rating)
      end

      it "re-renders the 'edit' template" do
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do

    before { rating }

    context "messages receiving" do

      after { delete :destroy, {:id => rating.to_param} }

      it_behaves_like "customer authentication"
      # it_behaves_like "rating setting"
    end

    it "destroys the requested rating" do
      expect {
        delete :destroy, {:id => rating.to_param}
      }.to change(Rating, :count).by(-1)
    end

    it "redirects to the ratings list" do
      delete :destroy, {:id => rating.to_param}
      expect(response).to redirect_to(book_url(rating.book))
    end
  end

  # describe ".set_rating" do
  #   it "receives find on Rating and returns rating with requested id" do
  #     expect(Rating).to receive(:find).with(rating_params.id)
  #     controller.send(:set_rating)
  #   end
  # end

end
