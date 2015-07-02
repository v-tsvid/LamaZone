require 'rails_helper'

RSpec.describe "orders/index", type: :view do
  before(:each) do
    assign(:orders, [
      Order.create!(
        :state => 0,
        :total_price => "9.99",
        :completed_date => Date.tomorrow
      ),
      Order.create!(
        :state => 0,
        :total_price => "9.99",
        :completed_date => Date.tomorrow
      )
    ])
  end

  it "renders a list of orders" do
    render
    assert_select "tr>td", :text => 0.to_s, :count => 2
    assert_select "tr>td", :text => "9.99".to_s, :count => 2
  end
end
