require 'rails_helper'

RSpec.describe "Addresses", type: :request do

  let (:customer) { FactoryGirl.create :customer }

  before(:each) do
    Warden.test_mode!
    login_as(customer)
  end

  after(:each) do
    logout(customer)
    Warden.test_reset!
  end
  
  describe "GET /addresses" do
    it "works! (now write some real specs)" do

      get customer_addresses_path(customer)
      expect(response).to have_http_status(200)
    end
  end
end
