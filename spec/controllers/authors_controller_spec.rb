require 'rails_helper'
require 'shared/controllers/shared_controllers_specs'

RSpec.describe AuthorsController, type: :controller do

  describe "GET #show" do
    let(:author) { FactoryGirl.create :author }

    subject { get :show, {id: author.to_param} }

    it_behaves_like "load and authorize resource", :author
    it_behaves_like 'check abilities', :read, Author
  end
end
