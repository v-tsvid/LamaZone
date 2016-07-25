require 'rails_helper'
require 'shared/controllers/shared_controllers_specs'

RSpec.describe StaticPagesController, type: :controller do


  describe "GET #home" do
    subject { get :home }

    it_behaves_like 'assigning', :books
  end
end
