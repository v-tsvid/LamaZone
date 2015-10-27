require 'rails_helper'

RSpec.describe "ratings/index", type: :view do
  before do
    @ratings = FactoryGirl.create_list :rating, 2
    render
  end

  it "renders _rating partial" do
    expect(view).to render_template(partial: '_rating', count: 2)
  end

  [:rate, :review].each do |item|
    it "displays ratings' #{item.to_s.pluralize}" do
      [0, 1].each do |num|
        expect(rendered).to match(@ratings[num].send(item).to_s)
      end
    end
  end
end
