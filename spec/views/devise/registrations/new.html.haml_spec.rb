require 'rails_helper'

shared_examples "fields displaying" do |with_errors|

  before do
    @customer = assign(:resource, FactoryGirl.build_stubbed(:customer))
  end

  [:email, :password, :password_confirmation].each do |item|

    if with_errors == true
      it "displays field for new customer's #{spaced(item)} with errors" do

        allow(@customer).to receive_message_chain("errors.messages") {
          { item => ["some_#{item}_error", "another_#{item}_error"]} }
      
        render
        expect(rendered).to have_selector(
          ".has-error input[id='customer_#{item.to_s}']")  
        expect(rendered).to have_selector(
          ".help-block", text:"some_#{item}_error, another_#{item}_error")
      end
    else
      it "displays field for new customer's #{spaced(item)}" do
        expect(rendered).to have_selector("div input[id='customer_#{item.to_s}']")  
      end
    end  
  end
end

RSpec.describe "devise/registrations/new", type: :view do
  
  context "when there is no error for the field" do
    it_behaves_like 'fields displaying', false
  end

  context "when there are errors for the field" do
    it_behaves_like 'fields displaying', true
  end

  before { render }

  it "renders _sign_up_fields partial for three times" do
    expect(view).to render_template(partial: "_sign_up_fields", count: 3)
  end

  it "renders _sign_up_field partial for three times" do
    expect(view).to render_template(partial: "_sign_up_field", count: 3)
  end

  it "renders devise shared links partial" do
    expect(view).to render_template(partial: "devise/shared/_links")
  end
  
  it "displays linked facebook logo for facebook sign up" do
    selector = "a[href='#{customer_omniauth_authorize_path(:facebook)}'] "\
               "img[src*='fb.png']"
    expect(rendered).to have_selector(selector)
  end

  it "displays sign up button" do
    expect(rendered).to have_selector("input[type=submit][value='Sign up']")
  end

  it "displays sign in link" do
    expect(rendered).to have_link('Sign in', '/customers/sign_in')
  end
end