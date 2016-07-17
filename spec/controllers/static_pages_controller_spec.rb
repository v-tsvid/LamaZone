require 'rails_helper'
require 'controllers/shared/shared_controller_specs'

RSpec.describe StaticPagesController, type: :controller do


  describe "GET #home" do
    subject { get :home }

    it_behaves_like 'assigning', :books
  end
end
