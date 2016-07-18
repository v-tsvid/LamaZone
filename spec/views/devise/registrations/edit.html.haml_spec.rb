require 'rails_helper'

RSpec.describe "devise/registrations/edit", type: :view do

  before do 
    @customer = assign(:resource, FactoryGirl.build_stubbed(:customer))
    assign(:billing_address, FactoryGirl.build_stubbed(:address))
    assign(:shipping_address, FactoryGirl.build_stubbed(:address))
    render 
  end

  shared_examples "errors displaying" do |item|

    it "displays error message if #{item} has an error" do
      allow(@customer).to receive_message_chain("errors.messages") {
        { item => ["some_#{item}_error", "another_#{item}_error"]} }
      
      render
      expect(rendered).to have_selector(
        ".help-block", text:"some_#{item}_error, another_#{item}_error")
    end
  end

  shared_examples "address fields displaying" do
    
    it "displays header for address fields" do
      expect(rendered).to match "#{subject.upcase} ADDRESS"
    end

    [:firstname, 
     :lastname, 
     :phone, 
     :address1, 
     :address2, 
     :city, 
     :zipcode].each do |item|
      it "displays fields for address #{item}" do
        expect(rendered).to have_selector(
          ".#{subject}_address_form input[type=text][id='address_#{spaced(item)}']")
      end
    end

    it "displays select for address country" do
      expect(rendered).to have_selector(
        ".#{subject}_address_form select[id='address_country_id']")
    end

    it "displays SAVE button" do
      expect(rendered).to have_selector(
        ".#{subject}_address_form input[type=submit][value='SAVE']")
    end
  end

  it "renders _form partial twice" do
    expect(view).to render_template(partial: "_form", count: 2)
  end

  it "displays caption" do
    expect(rendered).to match t("settings_page.settings")
  end

  context "fields for billing address" do

    subject { 'billing' }
    
    it_behaves_like 'address fields displaying'

  end

  context "fields for shipping address" do

    subject { 'shipping' }
    
    it_behaves_like 'address fields displaying'

  end

  context "fields for email updating" do

    it "displays field for customer's email" do
      expect(rendered).to have_selector("input[type=email][id='customer_email']")
    end

    it_behaves_like "errors displaying", :email


    it "displays SAVE button" do
      expect(rendered).to have_selector(
        ".email_form input[type=submit][value='SAVE']")
    end
  end

  context 'fields for password updating' do
    [:password, :current_password].each do |item|
      it "displays field for customer's #{item}" do
        expect(rendered).to have_selector(
          "input[type=password][id='customer_#{item}']") 
      end

      it_behaves_like "errors displaying", item 
    end

    it "displays SAVE button" do
      expect(rendered).to have_selector(
        ".password_form input[type=submit][value='SAVE']")
    end
  end

  context "fields for account removing" do
    it "displays account removing button" do
      expect(rendered).to have_selector("input[type=submit][value='PLEASE REMOVE MY ACCOUNT']") 
    end

    it "displays checkbox for account removing" do
      expect(rendered).to have_selector("input[type=checkbox][id='confirm']")
    end

    it "displays label for checkbox" do
      expect(rendered).to have_text 'I understand that all data will be lost'
    end
  end
end