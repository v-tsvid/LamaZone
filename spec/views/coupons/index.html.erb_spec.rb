require 'rails_helper'

RSpec.describe "coupons/index", type: :view do
  before(:each) do
    assign(:coupons, [
      Coupon.create!(
        :code => "Code",
        :discount => 1
      ),
      Coupon.create!(
        :code => "Code",
        :discount => 1
      )
    ])
  end

  it "renders a list of coupons" do
    render
    assert_select "tr>td", :text => "Code".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
