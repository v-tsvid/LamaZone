require 'rails_helper'

shared_examples 'for any user' do
  before { render }

  it "has the title \"LamaZone\"" do
    expect(rendered).to have_title 'LamaZone'
  end

  it 'has the brand logo' do
    expect(rendered).to have_css "img[alt='LZ']"
  end

  it "has link \"Books\"" do
    expect(rendered).to have_link 'Books'
  end
end

shared_examples 'for signed in user' do
  before { render }

  ['Sign Out', 'My Profile'].each do |link|
    it "has link \"#{link}\"" do
      expect(rendered).to have_link link
    end
  end
end

describe 'layouts/application.html.haml' do

  before do
    allow(controller).to receive(:current_admin)
    allow(controller).to receive(:current_customer)
  end

  context 'for unsigned in user' do
    before do
      allow(controller).to receive(:current_admin) { false }
      allow(controller).to receive(:current_customer) { false }
      render
    end
    
    it_behaves_like 'for any user'

    ['Sign In', 'Sign Up'].each do |link|
      it "has link \"#{link}\"" do
        expect(rendered).to have_link link
      end
    end
  end
  
  context 'for signed in customer' do
    before do
      allow(controller).to receive(:current_admin) { false }
      allow(controller).to receive(:current_customer) { true }
      render
    end

    it_behaves_like 'for any user'
    it_behaves_like 'for signed in user'
  end

  context 'for signed in admin' do
    before do
      allow(controller).to receive(:current_admin) { true }
      allow(controller).to receive(:current_customer) { false }
      render
    end

    it_behaves_like 'for any user'
    it_behaves_like 'for signed in user'

    it "has link \"Admin Panel\"" do
      expect(rendered).to have_link 'Admin Panel'
    end
  end
end