require 'rails_helper'
require 'shared/shared_specs'

RSpec.describe RatingsController, type: :controller do

  let(:customer) { FactoryGirl.create(:customer) }
  let(:book) { FactoryGirl.create(:book) }
  let(:rating_params) { 
    FactoryGirl.attributes_for(:rating, book_id: book.id).stringify_keys }
  let(:rating) { FactoryGirl.create(:rating, book_id: book.id, 
    customer_id: customer.id, state: 'approved') }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:customer]
    sign_in customer
  end

  describe "GET #new" do

    subject { get :new, { book_id: book.id } }

    it_behaves_like 'customer authentication'
    it_behaves_like 'authorize resource'
    it_behaves_like 'check abilities', :create, Rating
    
    [:book, :rating].each do |var|
      it_behaves_like 'assigning', var
    end
  end

  describe "POST #create" do

    subject { post :create, { rating: rating_params, book_id: book.id } }

    it_behaves_like 'customer authentication'
    it_behaves_like 'authorize resource'
    it_behaves_like 'check abilities', :create, Rating

    before { allow(Rating).to receive(:new).and_return rating }

    it "sets customer for rating with current_customer value" do
      subject
      expect(assigns(:rating).customer_id).to eq controller.current_customer.id
    end

    it "tries to save @rating" do
      expect(rating).to receive :save
      subject
    end

    context 'if @rating was saved' do
      before { allow(rating).to receive(:save).and_return true }

      it "redirects to book_path" do
        expect(subject).to redirect_to book_path(book)
      end

      it_behaves_like 'flash setting', :notice, t("controllers.rating_created")
    end

    context 'if @rating was NOT saved' do
      before { allow(rating).to receive(:save).and_return false }

      it "renders :new template" do
        expect(subject).to render_template :new
      end
    end
  end
end
