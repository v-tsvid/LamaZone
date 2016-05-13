require 'rails_helper'
require 'controllers/shared/shared_controller_specs'

RSpec.describe CategoriesController, type: :controller do

  let(:categories) { FactoryGirl.create_list :category_with_books, 2, num: 3}

  describe "GET #show" do
    subject { get :show, {id: categories[0].to_param} }

    it_behaves_like "load and authorize resource"

    it "assigns all categories as @categoies" do
      subject
      expect(assigns(:categories)).to eq(categories)
    end

    it "assigns current category as @categoy" do
      subject
      expect(assigns(:category)).to eq(categories[0])
    end

    it "assigns the books of the category as @books" do
      subject
      expect(assigns(:books)).to eq categories[0].books
    end
  end
end
