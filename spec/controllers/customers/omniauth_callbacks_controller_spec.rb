require 'rails_helper'

RSpec.describe Customers::OmniauthCallbacksController, type: :controller do

  before do 
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      'provider' => 'facebook',
      'uuid'     => "580001345483302",
      'facebook' => {
        'email' => "vad_1989@mail.ru",
        'first_name' => "Vadim",
        'last_name' => "Tsvid"
       }
    })

    OmniAuth.config.test_mode = true

    request.env["devise.mapping"] = Devise.mappings[:customer] # If using Devise
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]

    @customer = Customer.from_omniauth(request.env["omniauth.auth"])
  end

  describe "#facebook" do
    # it "assigns customer from omniauth as @customer" do
    #   get 'facebook'
    #   expect(assigns(:customer)).to eq @customer
    # end
  end

end