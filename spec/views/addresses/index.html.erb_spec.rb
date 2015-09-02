# require 'rails_helper'

# RSpec.describe "addresses/index", type: :view do
#   let(:country) { FactoryGirl.create :country}

#   before(:each) do
#     assign(:addresses, [
#       Address.create!(
#         :phone => "380930000000",
#         :address1 => "Address1",
#         :address2 => "Address2",
#         :city => "City",
#         :zipcode => "Zipcode",
#         :country_id => country.id
#       ),
#       Address.create!(
#         :phone => "380930000000",
#         :address1 => "Address1",
#         :address2 => "Address2",
#         :city => "City",
#         :zipcode => "Zipcode",
#         :country_id => country.id
#       )
#     ])
#   end

#   it "renders a list of addresses" do
#     render
#     assert_select "tr>td", :text => "380930000000".to_s, :count => 2
#     assert_select "tr>td", :text => "Address1".to_s, :count => 2
#     assert_select "tr>td", :text => "Address2".to_s, :count => 2
#     assert_select "tr>td", :text => "City".to_s, :count => 2
#     assert_select "tr>td", :text => "Zipcode".to_s, :count => 2
#   end
# end
