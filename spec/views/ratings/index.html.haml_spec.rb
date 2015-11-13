require 'rails_helper'

RSpec.describe "ratings/index", type: :view do
  before(:each) do
    @customer = stub_model(Customer)
    @wrong_customer = stub_model(Customer)
    assign(:ratings, [stub_model(Rating, 
                        rate: 6,
                        review: 'some_review',
                        customer_id: @customer.id
                        ),
                      stub_model(Rating,  
                        rate: 9,
                        review: 'another_review',
                        customer_id: @customer.id)])
  end

  context "for every customer" do
    before do
      allow(controller).to receive(:current_user)
      render
    end

    it "renders _rating partial" do
      expect(view).to render_template(partial: '_rating', count: 2)
    end

    it "displays ratings' rate" do
      expect(rendered).to match /6/
      expect(rendered).to match /9/
    end

    it "displays ratings' review" do
      expect(rendered).to match /some_review/
      expect(rendered).to match /another_review/
    end

    it "displays Show link for rating" do
      expect(rendered).to have_selector('a', text: 'Show')
    end
  end

  context "for current customer owns ratings" do
    before do
      allow(controller).to receive(:current_user).and_return(@customer)
      render
    end

    ['Edit', 'Destroy'].each do |item|
      it "displays #{item} link for ratings" do
        expect(rendered).to have_selector('a', text: item)
      end
    end
  end
  
  context "for current customer doesn't own ratings" do
    before do
      allow(controller).to receive(:current_user).and_return(@wrong_customer)
      render
    end

    ['Edit', 'Destroy'].each do |item|
      it "doesn't display #{item} link for ratings" do
        expect(rendered).not_to have_selector('a', text: item)
      end
    end
  end
end
