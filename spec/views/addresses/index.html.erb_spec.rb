require 'rails_helper'

RSpec.describe "addresses/index", type: :view do
  before(:each) do
    assign(:addresses, [
      Address.create!(
        :phone => "Phone",
        :address1 => "Address1",
        :address2 => "Address2",
        :city => "City",
        :zipcode => "Zipcode",
        :country => "Country"
      ),
      Address.create!(
        :phone => "Phone",
        :address1 => "Address1",
        :address2 => "Address2",
        :city => "City",
        :zipcode => "Zipcode",
        :country => "Country"
      )
    ])
  end

  it "renders a list of addresses" do
    render
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Address1".to_s, :count => 2
    assert_select "tr>td", :text => "Address2".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "Zipcode".to_s, :count => 2
    assert_select "tr>td", :text => "Country".to_s, :count => 2
  end
end
