require 'rails_helper'

RSpec.describe "devise/registrations/edit", type: :view do

  before do 
    assign(:resource, FactoryGirl.build_stubbed(:customer))
    render 
  end

  shared_examples "address fields displaying" do
    
    it "displays header for address fields" do
      expect(rendered).to match "My #{subject} address"
    end

    ['firstname', 
     'lastname', 
     'phone', 
     'address1', 
     'address2', 
     'city', 
     'zipcode'].each do |item|
      it "displays fields for address #{item}" do
        expect(rendered).to match "#{item.capitalize}"
        expect(rendered).to have_selector(
          "input[type=text][id='customer_#{subject}_address_attributes_#{item}']")
      end
    end

    it "displays select for address country" do
      expect(rendered).to match 'Country'
      expect(rendered).to have_selector(
        "select[id='customer_#{subject}_address_attributes_country_id']")
    end
  end

  it "renders _form partial twice" do
    expect(view).to render_template(partial: "_form", count: 2)
  end

  it "displays caption" do
    expect(rendered).to match 'Edit Customer'
  end

  context "displaying fields for billing address" do

    subject { 'billing' }
    
    it_behaves_like 'address fields displaying'

  end

  context "displaying fields for shipping address" do

    subject { 'shipping' }
    
    it_behaves_like 'address fields displaying'

  end

  it "displays field for customer's email" do
    expect(rendered).to match 'email'
    expect(rendered).to have_selector("input[type=email][id='customer_email']")
  end

  ['password', 'password confirmation', 'current password'].each do |item|
    it "displays field for customer's #{item}" do
      expect(rendered).to match item.capitalize
      expect(rendered).to have_selector(
        "input[type=password][id='customer_#{item.tr(' ', '_')}']") 
    end
  end

  it "displays update button" do
    expect(rendered).to have_selector("input[type=submit][value='Update']") 
  end

  it "displays account cancellation button" do
    expect(rendered).to have_selector("input[type=submit][value='Cancel my account']") 
  end

  it "displays back link" do
    expect(rendered).to have_link('Back', '/books?category=1')
  end
end