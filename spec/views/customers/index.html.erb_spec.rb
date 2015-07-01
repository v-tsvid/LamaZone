require 'rails_helper'

RSpec.describe "customers/index", type: :view do
  before(:each) do
    assign(:customers, [
      Customer.create!(
        :email => "Email1",
        :password => "Password",
        :password_confirmation => "Password Confirmation",
        :firstname => "Firstname",
        :lastname => "Lastname"
      ),
      Customer.create!(
        :email => "Email2",
        :password => "Password",
        :password_confirmation => "Password Confirmation",
        :firstname => "Firstname",
        :lastname => "Lastname"
      )
    ])
  end

  it "renders a list of customers" do
    render
    assert_select "tr>td", :text => "Email1".to_s, :count => 1
    assert_select "tr>td", :text => "Email2".to_s, :count => 1
    assert_select "tr>td", :text => "Password".to_s, :count => 2
    assert_select "tr>td", :text => "Password Confirmation".to_s, :count => 2
    assert_select "tr>td", :text => "Firstname".to_s, :count => 2
    assert_select "tr>td", :text => "Lastname".to_s, :count => 2
  end
end
