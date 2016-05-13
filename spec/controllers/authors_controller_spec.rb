require 'rails_helper'
require 'controllers/shared/shared_controller_specs'

RSpec.describe AuthorsController, type: :controller do

  describe "GET #show" do
    let(:author) { FactoryGirl.create :author }
    subject { get :show, {id: author.to_param} }

    it_behaves_like "load and authorize resource"
    
    it "assigns the requested author as @author" do
      subject
      expect(assigns(:author)).to eq(author)
    end
  end
end
