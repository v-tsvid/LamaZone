require 'rails_helper'
require 'shared/controllers/shared_controllers_specs'

RSpec.describe CategoriesController, type: :controller do

  let(:categories) { FactoryGirl.create_list :category_with_books, 2, num: 3}

  describe "GET #show" do
    subject { get :show, {id: categories[0].to_param} }

    it_behaves_like "load and authorize resource", :category
    it_behaves_like 'check abilities', :read, Category

    [:books, :categories].each do |var|
      it_behaves_like 'assigning', var
    end
  end
end
