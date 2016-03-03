require 'rails_helper'

RSpec.describe "devise/registrations/new", type: :view do
  
  before { render }

  it "displays caption" do
    expect(rendered).to match 'Sign up'
  end

  it "displays field for new customer's email" do
    expect(rendered).to match 'email'
    expect(rendered).to have_selector("input[type=email][id='customer_email']")
  end

  ['password', 'password confirmation'].each do |item|
    it "displays field for new customer's #{item}" do
      expect(rendered).to match "#{item.capitalize}"
      expect(rendered).to have_selector(
        "input[type=password][id='customer_#{item.tr(' ', '_')}']")
    end
  end

  it "displays sign up button" do
    expect(rendered).to have_selector("input[type=submit][value='Sign up']")
  end

  it "displays sign in link" do
    expect(rendered).to have_link('Sign in', '/customers/sign_in')
  end

  it "displays facebook sign up link" do
    expect(rendered).to have_link(
      'Sign up with Facebook', href: '/customers/auth/facebook')
  end
end