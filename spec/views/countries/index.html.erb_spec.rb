require 'rails_helper'

RSpec.describe "countries/index", type: :view do
  before(:each) do
    assign(:countries, [
      Country.create!(
        :name => "Name1",
        :alpha2 => "NA"
      ),
      Country.create!(
        :name => "Name2",
        :alpha2 => "NM"
      )
    ])
  end

  it "renders a list of countries" do
    render
    assert_select "tr>td", :text => "Name1".to_s, :count => 1
    assert_select "tr>td", :text => "Name2".to_s, :count => 1
  end
end
