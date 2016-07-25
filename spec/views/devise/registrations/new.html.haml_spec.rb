require 'rails_helper'
require 'shared/views/shared_devise_view_specs'

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